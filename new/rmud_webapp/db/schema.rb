# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120630114000) do

  create_table "accounts", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true

  create_table "dictionary", :force => true do |t|
    t.string  "nominative"
    t.string  "genitive"
    t.string  "dative"
    t.string  "accusative"
    t.string  "instrumental"
    t.string  "locative"
    t.string  "plu_nominative"
    t.string  "plu_genitive"
    t.string  "plu_dative"
    t.string  "plu_accusative"
    t.string  "plu_instrumental"
    t.string  "plu_locative"
    t.integer "gender_id"
  end

  create_table "gender", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  create_table "players", :force => true do |t|
    t.string   "name",          :null => false
    t.integer  "account_id"
    t.integer  "dictionary_id"
    t.datetime "last_login"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
