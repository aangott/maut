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

ActiveRecord::Schema.define(:version => 20150320134009) do

  create_table "decision_problems", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dimensions", :force => true do |t|
    t.text     "description"
    t.integer  "rank"
    t.integer  "weight"
    t.integer  "decision_problem_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "dimensions", ["decision_problem_id"], :name => "index_dimensions_on_decision_problem_id"

  create_table "options", :force => true do |t|
    t.text     "description"
    t.integer  "decision_problem_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "options", ["decision_problem_id"], :name => "index_options_on_decision_problem_id"

  create_table "ratings", :force => true do |t|
    t.integer  "value"
    t.integer  "dimension_id"
    t.integer  "option_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "rank"
  end

  add_index "ratings", ["dimension_id"], :name => "index_ratings_on_dimension_id"
  add_index "ratings", ["option_id"], :name => "index_ratings_on_option_id"

end
