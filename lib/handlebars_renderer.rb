class HandlebarsRenderer
  attr_reader :handlebars
  def initialize
    @handlebars = Handlebars::Handlebars.new
  end

  def render(template_string, bindings)
    template = handlebars.compile(sanitize_template(template_string))
    template.call(bindings)
  end

  private

  def sanitize_template(template_string)
    template_string.gsub('{{# if', '{{#if')
  end
end
