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

ActiveRecord::Schema.define(version: 20160407155701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "comments", ["recipe_id"], name: "index_comments_on_recipe_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "components", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
  end

  add_index "components", ["ingredient_id"], name: "index_components_on_ingredient_id", using: :btree
  add_index "components", ["recipe_id"], name: "index_components_on_recipe_id", using: :btree

  create_table "favorites_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "favorites_memberships", ["recipe_id"], name: "index_favorites_memberships_on_recipe_id", using: :btree
  add_index "favorites_memberships", ["user_id"], name: "index_favorites_memberships_on_user_id", using: :btree

  create_table "ingredient_ratings", force: :cascade do |t|
    t.integer  "rating"
    t.datetime "expiration"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.integer  "ingredient_id"
  end

  add_index "ingredient_ratings", ["ingredient_id"], name: "index_ingredient_ratings_on_ingredient_id", using: :btree
  add_index "ingredient_ratings", ["user_id"], name: "index_ingredient_ratings_on_user_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_recipes_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "my_recipes_memberships", ["recipe_id"], name: "index_my_recipes_memberships_on_recipe_id", using: :btree
  add_index "my_recipes_memberships", ["user_id"], name: "index_my_recipes_memberships_on_user_id", using: :btree

  create_table "recipe_ratings", force: :cascade do |t|
    t.integer  "quality"
    t.integer  "difficulty"
    t.integer  "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "recipe_id"
  end

  add_index "recipe_ratings", ["recipe_id"], name: "index_recipe_ratings_on_recipe_id", using: :btree
  add_index "recipe_ratings", ["user_id"], name: "index_recipe_ratings_on_user_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "guide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "comments", "recipes"
  add_foreign_key "comments", "users"
  add_foreign_key "components", "ingredients"
  add_foreign_key "components", "recipes"
  add_foreign_key "favorites_memberships", "recipes"
  add_foreign_key "favorites_memberships", "users"
  add_foreign_key "ingredient_ratings", "ingredients"
  add_foreign_key "ingredient_ratings", "users"
  add_foreign_key "my_recipes_memberships", "recipes"
  add_foreign_key "my_recipes_memberships", "users"
  add_foreign_key "recipe_ratings", "recipes"
  add_foreign_key "recipe_ratings", "users"
  add_foreign_key "recipes", "users"
end
