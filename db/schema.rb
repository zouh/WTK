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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141010012217) do

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.integer  "order_id"
    t.integer  "quantity",   default: 1
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id"
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "members", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "organization_id"
    t.string   "invite_code"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "depth",           default: 0
    t.integer  "children_count",  default: 0
    t.integer  "points",          default: 0
    t.integer  "role",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["depth"], name: "index_members_on_depth"
  add_index "members", ["invite_code"], name: "index_members_on_invite_code", unique: true
  add_index "members", ["organization_id"], name: "index_members_on_organization_id"
  add_index "members", ["parent_id"], name: "index_members_on_parent_id"
  add_index "members", ["user_id"], name: "index_members_on_user_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "oid"
    t.integer  "member_id"
    t.integer  "ship_to"
    t.integer  "status"
    t.decimal  "total"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["member_id"], name: "index_orders_on_member_id"
  add_index "orders", ["organization_id"], name: "index_orders_on_organization_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "contract"
    t.string   "invite_code"
    t.string   "logo_url"
    t.integer  "capacity"
    t.integer  "level"
    t.decimal  "rate1",          default: 0.0
    t.decimal  "rate2",          default: 0.0
    t.decimal  "rate3",          default: 0.0
    t.decimal  "rate4",          default: 0.0
    t.decimal  "rate5",          default: 0.0
    t.decimal  "rate6",          default: 0.0
    t.integer  "period"
    t.integer  "members_count",  default: 0
    t.integer  "products_count", default: 0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true

  create_table "products", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "oid"
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price",           precision: 8, scale: 2
    t.decimal  "retail",          precision: 8, scale: 2
    t.decimal  "wholesale",       precision: 8, scale: 2
    t.boolean  "qualify",                                 default: false
    t.decimal  "rate0",                                   default: 0.0
    t.decimal  "rate1",                                   default: 0.0
    t.decimal  "rate2",                                   default: 0.0
    t.decimal  "rate3",                                   default: 0.0
    t.decimal  "rate4",                                   default: 0.0
    t.decimal  "rate5",                                   default: 0.0
    t.decimal  "rate6",                                   default: 0.0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["organization_id", "name"], name: "index_products_on_organization_id_and_name", unique: true
  add_index "products", ["organization_id"], name: "index_products_on_organization_id"

  create_table "rewards", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "line_item_id"
    t.integer  "member_id"
    t.decimal  "amount"
    t.decimal  "rate"
    t.decimal  "points"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rewards", ["line_item_id"], name: "index_rewards_on_line_item_id"
  add_index "rewards", ["member_id"], name: "index_rewards_on_member_id"
  add_index "rewards", ["order_id"], name: "index_rewards_on_order_id"

  create_table "users", force: :cascade do |t|
    t.string   "oid"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "avatar_url"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
