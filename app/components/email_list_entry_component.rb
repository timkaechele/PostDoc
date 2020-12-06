class EmailListEntryComponent < ViewComponent::Base
  attr_reader :email
  def initialize(email:)
    @email = email
  end

  def email_modifier_class
    return 'email--read' if email.read?
    'email--unread'
  end
end
