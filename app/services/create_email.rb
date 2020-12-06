require 'handlebars_renderer'
require 'sendgrid_client'

class CreateEmail
  class InvalidRequest < StandardError
    attr_reader :request_result
    def initialize(request_result)
      super()
      @request_result = request_result
    end
  end

  class InvalidTemplate < StandardError
  end

  attr_reader :mailbox,
              :handlebars_renderer,
              :sendgrid_client

  def initialize(mailbox,
                 handlebars_renderer: HandlebarsRenderer.new,
                 sendgrid_client_class: SendgridClient)

    @mailbox = mailbox
    @handlebars_renderer = handlebars_renderer
    @sendgrid_client = sendgrid_client_class.new(mailbox.sendgrid_api_token)
  end

  def call(request_payload)
    validate_email_payload_against_sendgrid!(request_payload)
    template = retrieve_template_payload(template_id(request_payload))
    render_personalizations(request_payload, template)
  end

  private

  def validate_email_payload_against_sendgrid!(request_payload)
    result = sendgrid_client.validate_request(request_payload)
    raise InvalidRequest.new(result.original_response) unless result.valid
  end

  def retrieve_template_payload(template_id)
    result = sendgrid_client.get_template(template_id)
    raise InvalidTemplate if result.blank?
    result
  end

  def render_personalizations(request_payload, template)
    request_payload['personalizations'].each_with_index do |personalization, index|
      template_version = latest_template_version(template)
      Email.new(mailbox: mailbox,
                request_payload: request_payload,
                template_payload: template,
                template_id: template_version['id'],
                personalization_id: index,
                rendered_html: render_html(template_version, personalization),
                rendered_plain_text: render_plaintext(template_version, personalization),
                subject: render_subject(template_version, personalization)
                ).save!
    end
  end

  def render_subject(template_version, personalization)
    handlebars_renderer.render(template_version['subject'],
                               { 'subject' => personalization['subject'] })
  end

  def render_html(template_version, personalization)
    handlebars_renderer.render(template_version['html_content'],
                               personalization['dynamic_template_data'])
  end

  def render_plaintext(template_version, personalization)
    if template_version['generate_plain_content']
      document = Nokogiri::HTML(render_html(template_version, personalization))
      document.text()
    else
      handlebars_renderer.render(template_version['plain_content'], personalization)
    end
  end

  def template_id(request_payload)
    request_payload['template_id']
  end

  def latest_template_version(template)
    template['versions'].last
  end
end
