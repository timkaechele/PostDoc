class Mailbox < ApplicationRecord
  has_many :emails, dependent: :destroy

  validates :name, presence: true

  validates :sendgrid_mock_api_token, presence: true
  validates :sendgrid_mock_api_token, uniqueness: true

  validates :sendgrid_api_token, presence: true

  before_validation :generate_sendgrid_mock_api_token

  def unread_count
    self.emails.unread.count
  end

  def mark_all_as_read!
    self.emails.unread.update_all(read_at: Time.zone.now)
  end

  private

  def generate_sendgrid_mock_api_token
    return if sendgrid_mock_api_token.present?
    self.sendgrid_mock_api_token = loop do
      token = SecureRandom.uuid
      break token unless self.class.exists?(sendgrid_mock_api_token: token)
    end
  end
end
