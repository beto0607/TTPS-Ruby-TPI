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

ActiveRecord::Schema.define(version: 2018_12_17_132304) do

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "status", default: false
    t.integer "user_id"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_questions_on_answer_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "expire_at"
    t.integer "user_id"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "screen_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
