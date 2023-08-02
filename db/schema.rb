# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_30_061913) do

  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicants", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recruit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recruit_id"], name: "index_applicants_on_recruit_id"
    t.index ["user_id", "recruit_id"], name: "index_applicants_on_user_id_and_recruit_id", unique: true
    t.index ["user_id"], name: "index_applicants_on_user_id"
  end

  create_table "chat_messages", charset: "utf8", force: :cascade do |t|
    t.string "content", default: "", null: false
    t.integer "chat_room_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chat_rooms", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", charset: "utf8", force: :cascade do |t|
    t.string "text", default: "", null: false
    t.bigint "user_id"
    t.bigint "recruit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recruit_id"], name: "index_comments_on_recruit_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "evaluations", charset: "utf8", force: :cascade do |t|
    t.bigint "evaluator_id", null: false
    t.bigint "evaluatee_id", null: false
    t.integer "score", null: false
    t.string "feedback", default: "", null: false
    t.integer "recruit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["evaluatee_id"], name: "index_evaluations_on_evaluatee_id"
    t.index ["evaluator_id"], name: "index_evaluations_on_evaluator_id"
  end

  create_table "favorites", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recruit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recruit_id"], name: "index_favorites_on_recruit_id"
    t.index ["user_id", "recruit_id"], name: "index_favorites_on_user_id_and_recruit_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "members", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "chat_room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", charset: "utf8", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.string "category", default: "", null: false
    t.integer "recruit_id"
    t.boolean "read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
  end

  create_table "recruit_tags", charset: "utf8", force: :cascade do |t|
    t.integer "recruit_id"
    t.integer "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recruits", charset: "utf8", force: :cascade do |t|
    t.integer "required_time", default: 0, null: false
    t.time "meeting_time", default: "2000-01-01 00:00:00", null: false
    t.boolean "closed", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: "", null: false
    t.string "explain", default: "", null: false
    t.date "date", default: "2023-07-30", null: false
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_recruits_on_user_id"
  end

  create_table "relations", charset: "utf8", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.bigint "recruit_id", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follower_id", "followed_id"], name: "index_relations_on_follower_id_and_followed_id", unique: true
    t.index ["recruit_id"], name: "index_relations_on_recruit_id"
  end

  create_table "tags", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "age", default: 0, null: false
    t.string "gender", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "activated", default: false
    t.text "introduce"
    t.float "score", default: 0.0, null: false
    t.integer "score_count", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicants", "recruits"
  add_foreign_key "applicants", "users"
  add_foreign_key "evaluations", "users", column: "evaluatee_id"
  add_foreign_key "evaluations", "users", column: "evaluator_id"
  add_foreign_key "favorites", "recruits"
  add_foreign_key "favorites", "users"
  add_foreign_key "recruits", "users"
  add_foreign_key "relations", "recruits"
end
