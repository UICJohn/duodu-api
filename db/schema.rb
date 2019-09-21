# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_19_150852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "code_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.integer "parent_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friend_requests_on_friend_id"
    t.index ["user_id"], name: "index_friend_requests_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "locations", force: :cascade do |t|
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "suburb"
    t.string "name"
    t.string "address"
    t.decimal "longitude", precision: 10, scale: 6
    t.decimal "latitude", precision: 10, scale: 6
    t.bigint "target_id"
    t.string "target_type"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "name"
    t.string "py"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "post_type"
    t.integer "property_id"
    t.integer "range"
    t.integer "min_rent"
    t.integer "max_rent"
    t.integer "rent"
    t.integer "payment_type"
    t.integer "user_id"
    t.integer "lease_type"
    t.integer "tenants"
    t.datetime "available_from"
    t.integer "livings"
    t.integer "rooms"
    t.integer "toilets"
    t.integer "cover_image_id"
    t.boolean "has_sofa"
    t.boolean "has_bed"
    t.boolean "has_air_conditioner"
    t.boolean "has_elevator"
    t.boolean "has_washing_machine"
    t.boolean "has_cook_top"
    t.boolean "has_refregitor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.boolean "show_privacy_data", default: false
    t.boolean "share_location", default: false
    t.boolean "receive_all_message", default: true
    t.bigint "user_id"
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "address"
    t.integer "unit"
    t.integer "floor"
    t.integer "number"
    t.integer "landlord_id"
    t.boolean "verified", default: false
    t.decimal "lng", precision: 10, scale: 6
    t.decimal "lat", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "property_id"
    t.string "title"
    t.text "body"
    t.integer "parent_id"
    t.string "parent_type"
    t.boolean "has_bathroom", default: false
    t.boolean "has_windows", default: false
    t.boolean "has_furniture", default: false
    t.boolean "has_air_conditioner", default: false
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_rooms_on_property_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "department"
    t.string "py"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_translations", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_tag_translations_on_locale"
    t.index ["tag_id"], name: "index_tag_translations_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "provider"
    t.string "uid"
    t.string "session_key"
    t.string "phone"
    t.date "dob"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "company"
    t.string "occupation"
    t.string "school"
    t.string "major"
    t.integer "password_status"
    t.text "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tags", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "friend_requests", "users"
  add_foreign_key "friend_requests", "users", column: "friend_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "rooms", "properties"
end
