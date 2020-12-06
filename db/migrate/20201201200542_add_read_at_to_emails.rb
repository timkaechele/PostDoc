class AddReadAtToEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :emails, :read_at, :timestamp
  end
end
