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

ActiveRecord::Schema.define(version: 2020_01_02_063249) do

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
    t.string "service_name", null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "target_id"
    t.string "target_type"
    t.integer "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "country_id"
    t.integer "province_id"
    t.integer "city_id"
    t.integer "suburb_id"
    t.string "name"
    t.string "address"
    t.decimal "longitude", precision: 10, scale: 6
    t.decimal "latitude", precision: 10, scale: 6
    t.bigint "target_id"
    t.string "target_type"
    t.index ["city_id"], name: "index_locations_on_city_id"
    t.index ["country_id"], name: "index_locations_on_country_id"
    t.index ["province_id"], name: "index_locations_on_province_id"
    t.index ["suburb_id"], name: "index_locations_on_suburb_id"
  end

  create_table "notification_templates", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "receiver_id"
    t.bigint "target_id"
    t.string "target_type"
    t.integer "template_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sender_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "name"
    t.string "py"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_collections", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_post_collections_on_post_id"
    t.index ["user_id"], name: "index_post_collections_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "type"
    t.string "title"
    t.text "body"
    t.integer "payment_type"
    t.integer "user_id"
    t.datetime "available_from"
    t.integer "rent"
    t.integer "livings"
    t.integer "rooms"
    t.integer "toilets"
    t.integer "cover_image_id"
    t.integer "property_type"
    t.integer "tenants", default: 0
    t.boolean "has_furniture", default: false
    t.boolean "has_appliance", default: false
    t.boolean "has_network", default: false
    t.boolean "has_air_conditioner", default: false
    t.boolean "has_elevator", default: false
    t.boolean "has_cook_top", default: false
    t.boolean "has_pets", default: false
    t.boolean "smoker", default: false
    t.boolean "pets_allow", default: false
    t.boolean "smoke_allow", default: false
    t.integer "tenants_gender", default: 2
    t.integer "area_ids", default: [], array: true
    t.integer "min_rent", default: 0
    t.integer "max_rent", default: 0
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.boolean "use_user_contact", default: false
    t.index ["livings"], name: "index_posts_on_livings"
    t.index ["rent"], name: "index_posts_on_rent"
    t.index ["rooms"], name: "index_posts_on_rooms"
    t.index ["tenants"], name: "index_posts_on_tenants"
    t.index ["toilets"], name: "index_posts_on_toilets"
    t.index ["type"], name: "index_posts_on_type"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.boolean "show_privacy_data", default: false
    t.boolean "share_location", default: false
    t.boolean "receive_all_message", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "region_translations", force: :cascade do |t|
    t.bigint "region_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["locale"], name: "index_region_translations_on_locale"
    t.index ["region_id"], name: "index_region_translations_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "type"
    t.string "code"
    t.string "baidu_id"
    t.string "tencent_id"
    t.integer "parent_id"
    t.string "pinyin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["baidu_id"], name: "index_regions_on_baidu_id"
    t.index ["parent_id"], name: "index_regions_on_parent_id"
    t.index ["pinyin"], name: "index_regions_on_pinyin"
    t.index ["tencent_id"], name: "index_regions_on_tencent_id"
    t.index ["type"], name: "index_regions_on_type"
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

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "source_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stations_subways", id: false, force: :cascade do |t|
    t.bigint "subway_id", null: false
    t.bigint "station_id", null: false
    t.index ["subway_id", "station_id"], name: "index_stations_subways_on_subway_id_and_station_id", unique: true
  end

  create_table "subways", force: :cascade do |t|
    t.string "name"
    t.string "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_subways_on_source_id"
  end

  create_table "survey_options", force: :cascade do |t|
    t.integer "survey_id"
    t.integer "position"
    t.text "body"
    t.boolean "custom_option", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.text "body"
    t.string "title"
    t.string "code_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tag_translations", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "user_surveys", force: :cascade do |t|
    t.integer "user_id"
    t.integer "survey_id"
    t.integer "survey_option_id"
    t.text "body"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "gender"
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

  create_table "warehouse_date_dimensions", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "warehouse_post_facts", force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.integer "date_id"
    t.integer "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "friend_requests", "users"
  add_foreign_key "friend_requests", "users", column: "friend_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "rooms", "properties"
end
