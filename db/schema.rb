# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_01_200542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emails", force: :cascade do |t|
    t.bigint "mailbox_id", null: false
    t.string "subject"
    t.string "template_id", null: false
    t.string "rendered_html", null: false
    t.string "rendered_plain_text", null: false
    t.jsonb "request_payload", null: false
    t.integer "personalization_id", null: false
    t.jsonb "template_payload", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "read_at"
    t.index ["mailbox_id"], name: "index_emails_on_mailbox_id"
  end

  create_table "mailboxes", force: :cascade do |t|
    t.string "name", null: false
    t.string "sendgrid_mock_api_token", null: false
    t.string "sendgrid_api_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sendgrid_mock_api_token"], name: "index_mailboxes_on_sendgrid_mock_api_token", unique: true
  end

  add_foreign_key "emails", "mailboxes", on_update: :cascade, on_delete: :cascade
end
