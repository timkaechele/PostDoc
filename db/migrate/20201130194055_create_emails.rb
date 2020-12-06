class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.references :mailbox, null: false, foreign_key: {
        on_delete: :cascade,
        on_update: :cascade
      }
      t.string :subject
      t.string :template_id, null: false

      t.string :rendered_html, null: false
      t.string :rendered_plain_text, null: false

      t.jsonb :request_payload, null: false
      t.integer :personalization_id, null: false
      t.jsonb :template_payload, null: false

      t.timestamps
    end
  end
end
