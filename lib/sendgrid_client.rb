class SendgridClient
  class TemplateValidationResult < Struct.new(:valid, :original_response); end

  def initialize(api_token)
    @faraday_client = setup_faraday_client!(api_token)
  end

  def get_template(template_id)
    response = faraday_client.get("templates/#{template_id}")
    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def validate_request(request_payload)
    sandboxed_request_payload = request_payload.merge(sandbox_parameters)

    response = faraday_client.post('mail/send', sandboxed_request_payload.to_json)

    TemplateValidationResult.new(response.status == 200, response)
  end

  private

  attr_reader :faraday_client

  def setup_faraday_client!(api_token)
    Faraday.new('https://api.sendgrid.com/v3/', request: { timeout: 5 }) do |connection|
      connection.headers = {
        accept: 'application/json',
        'Content-Type': 'application/json'
      }

      connection.authorization(:Bearer, api_token)
    end
  end
  def sandbox_parameters
    {
      'mail_settings' => {
        'sandbox_mode' => {
          'enable' => true
        }
      }
    }
  end
end
