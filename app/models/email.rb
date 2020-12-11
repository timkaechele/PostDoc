class Email < ApplicationRecord
  belongs_to :mailbox
  validates :template_id, presence: true
  validates :rendered_html, presence: true
  validates :request_payload, presence: true
  validates :template_payload, presence: true
  validates :personalization_id, presence: true

  validates :rendered_html, presence: true
  validates :rendered_plain_text, presence: true

  def self.search(query)
    Search::EmailSearch.new.search(self, query)
  end

  def self.unread
    where(read_at: nil)
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    self.update(read_at: Time.zone.now)
  end

  def from
    fields = request_payload['from']
    EmailAddress.new(email: fields['email'], name: fields['name'])
  end

  def to
    personalization['to'].map do |fields|
      EmailAddress.new(email: fields['email'], name: fields['name'])
    end
  end

  def cc
    return [] unless personalization['cc'].present?
    personalization['cc'].map do |fields|
      EmailAddress.new(email: fields['email'], name: fields['name'])
    end
  end

  def bcc
    return [] unless personalization['bcc'].present?
    personalization['bcc'].map do |fields|
      EmailAddress.new(email: fields['email'], name: fields['name'])
    end
  end

  def personalization
    request_payload['personalizations'][personalization_id]
  end

  def link_to_template
    "https://mc.sendgrid.com/dynamic-templates/#{template_id}/version/#{template_version}/editor"
  end

  def template_name
    template_payload['name']
  end

  def template_version
    template_payload['versions'].last['id']
  end
end
