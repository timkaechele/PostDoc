class ApplicationController < ActionController::Base
  http_basic_authenticate_with(
    name: Rails.application.secrets.username,
    password: Rails.application.secrets.password)

  helper_method :mailboxes, :current_mailbox

  def mailboxes
    @mailboxes ||= Mailbox.all.order(name: :asc)
  end

  def current_mailbox
    @mailbox
  end
end
