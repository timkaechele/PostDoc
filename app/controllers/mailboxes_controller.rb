class MailboxesController < ApplicationController
  before_action :set_mailbox, only: [:show, :mark_all_as_read, :clear_mailbox, :details, :edit, :update, :destroy]

  def index
    if Mailbox.any?
      return redirect_to mailbox_path(Mailbox.first)
    end
  end

  def show
    @emails = @mailbox.emails.order(created_at: :desc)
  end

  def details
    render(partial: 'details', layout: false)
  end

  def new
    @mailbox = Mailbox.new
    render(layout: false)
  end

  def create
    @mailbox = Mailbox.new(mailbox_params)
    if @mailbox.save
      flash[:success] = 'Successfully created mailbox.'
      redirect_to mailbox_path(@mailbox)
    else
      render partial: 'form', status: :bad_request, layout: false
    end
  end

  def edit
    render(layout: false)
  end

  def update
    if @mailbox.update(mailbox_params)
      flash[:success] = 'Successfully updated'
      redirect_to mailbox_path(@mailbox)
    else
      render partial: 'form', status: :bad_request, layout: false
    end
  end

  def mark_all_as_read
    @mailbox.mark_all_as_read!
    redirect_to mailbox_path(@mailbox)
  end

  def clear_mailbox
    @mailbox.emails.destroy_all
    redirect_to mailbox_path(@mailbox)
  end

  def destroy
    @mailbox.destroy
    flash[:success] = 'Successfully destroyed mailbox'
    redirect_to mailboxes_path
  end

  private

  def mailbox_params
    params.require(:mailbox).permit(:name, :sendgrid_api_token)
  end

  def set_mailbox
    @mailbox = Mailbox.find(params[:id])
  end
end
