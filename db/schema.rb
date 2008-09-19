# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080919090959) do

  create_table "bills", :force => true do |t|
    t.integer  "category_id", :limit => 11
    t.decimal  "amount",                    :precision => 10, :scale => 2
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "creator_id",  :limit => 11
    t.string   "currency",    :limit => 3
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debts", :force => true do |t|
    t.integer  "creditor_id", :limit => 11
    t.integer  "debitor_id",  :limit => 11
    t.decimal  "amount",                    :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",    :limit => 3
  end

  create_table "groups", :force => true do |t|
    t.string   "name",        :limit => 40
    t.string   "description",               :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id",   :limit => 11
    t.integer  "user_id",    :limit => 11
    t.datetime "created_at"
    t.boolean  "admin"
  end

  create_table "payments", :force => true do |t|
    t.integer  "bill_id",    :limit => 11
    t.integer  "user_id",    :limit => 11
    t.decimal  "amount",                   :precision => 10, :scale => 2
    t.boolean  "accepted",                                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
