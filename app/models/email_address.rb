class EmailAddress
  attr_reader :email, :name
  def initialize(email: ,name: nil)
    @email = email
    @name = name
  end
  def to_s
    "<#{email}> #{name}".strip
  end
end
