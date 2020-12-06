module Api
  class EmailsController < BaseController
    def create
      email_payload = request.request_parameters
      begin
        CreateEmail.new(current_mailbox).call(email_payload)
      rescue CreateEmail::InvalidRequest => exception
        request_result = exception.request_result
        request_body = JSON.parse(request_result.body)
        render(json: request_body, status: request_result.status)
      rescue CreateEmail::InvalidTemplate => _e
        response_payload = {
          'errors' => [
            {
              'message' => 'Could not find template with given id.',
              'field' => 'template_id',
              'help' => nil
            }
          ]
        }

        render(json: response_payload, status: 400)
      end
    end
  end
end
