class CreateMailboxes < ActiveRecord::Migration[6.0]
  def change
    create_table :mailboxes do |t|
      t.string :name, null: false
      t.string :sendgrid_mock_api_token, null: false
      t.string :sendgrid_api_token, null: false

      t.timestamps
    end
    add_index :mailboxes, :sendgrid_mock_api_token, unique: true
  end
end
