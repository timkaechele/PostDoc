class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :mark_as_read, :body_preview]

  def show
    @selected = params[:selected]
    @email.mark_as_read! unless @email.read?
  end

  def body_preview
    render(layout: false)
  end

  def set_email
    @email = Email.find(params[:id])
    @mailbox = @email.mailbox
  end
end
