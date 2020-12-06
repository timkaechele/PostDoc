require 'test_helper'

class MailboxTest < ActiveSupport::TestCase
  test "generates a sendgrid mock api token on save" do
    mailbox = Mailbox.new(name: 'My Mailbox',
                            sendgrid_api_token: '1234')

    mailbox.save

    assert_predicate mailbox.sendgrid_mock_api_token, :present?
  end

  test "does not regenerate the sendgrid_mock_api_token on save" do
    mailbox = Mailbox.new(name: 'My Mailbox',
                            sendgrid_api_token: '1234',
                            sendgrid_mock_api_token: 'This is my test token')
    mailbox.save
    assert_equal 'This is my test token', mailbox.sendgrid_mock_api_token
  end
end
