module Api
  class BaseController < ActionController::Base
    before_action :authenticate_mailbox
    protect_from_forgery with: :null_session

    def require_mailbox
    end

    def authenticate_mailbox
      authenticate_or_request_with_http_token do |token, _options|
        puts token
        Mailbox.find_by(sendgrid_mock_api_token: token)
      end
    end


    def current_mailbox
      @mailbox ||= authenticate_mailbox
    end
  end
end
