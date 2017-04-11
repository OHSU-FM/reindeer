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

ActiveRecord::Schema.define(version: 20170411183744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chart_series", force: :cascade do |t|
    t.integer  "chart_id"
    t.text     "group_filter"
    t.text     "entity_filter"
    t.text     "category_filter"
    t.text     "question_filter"
    t.text     "question_options_filter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chart_series", ["chart_id"], name: "index_chart_series_on_chart_id", using: :btree

  create_table "charts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "title"
    t.text     "output"
    t.text     "chart_type"
    t.text     "aggregator_type"
    t.text     "cols"
    t.text     "rows"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charts", ["user_id"], name: "index_charts_on_user_id", using: :btree

  create_table "content_slugs", force: :cascade do |t|
    t.integer "user_id"
    t.text    "content"
    t.boolean "public"
    t.integer "sizex"
    t.integer "sizey"
    t.boolean "resizeable", default: true
  end

  create_table "critical_values", id: false, force: :cascade do |t|
    t.integer "df",                   null: false
    t.decimal "t",                    null: false
    t.decimal "alpha", default: 0.05, null: false
  end

  create_table "dashboard_widgets", force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "position"
    t.integer "sizex"
    t.integer "sizey"
    t.boolean "resizeable",               default: true
    t.text    "widget_type"
    t.integer "widget_id"
    t.string  "widget_title", limit: 255
  end

  create_table "dashboards", force: :cascade do |t|
    t.integer "user_id"
    t.text    "theme"
  end

  add_index "dashboards", ["user_id"], name: "index_dashboards_on_user_id", using: :btree

  create_table "data_migrations", force: :cascade do |t|
    t.text "version", null: false
  end

  create_table "meta_attribute_entities", force: :cascade do |t|
    t.text    "entity_type",                                                       null: false
    t.text    "meta_attribute_entity_group_group_name",                            null: false
    t.integer "edition"
    t.integer "version"
    t.date    "start_date"
    t.date    "stop_date"
    t.boolean "visible",                                            default: true
    t.integer "reference_year"
    t.string  "entity_type_fk",                         limit: 255
  end

  add_index "meta_attribute_entities", ["entity_type"], name: "ix_meta_attribute_entities", unique: true, using: :btree

  create_table "meta_attribute_questions", force: :cascade do |t|
    t.text    "meta_attribute_entity_entity_type",                null: false
    t.text    "category"
    t.text    "attribute_name"
    t.text    "description"
    t.text    "original_text"
    t.text    "data_type"
    t.text    "options_hash"
    t.boolean "continuous"
    t.boolean "optional"
    t.boolean "visible",                           default: true
    t.text    "short_name"
  end

  create_table "meta_attribute_statistics", primary_key: "meta_attribute_statistic_id", force: :cascade do |t|
    t.string  "subset_id"
    t.string  "entity_schema"
    t.string  "entity_name"
    t.integer "attribute_index",       limit: 8
    t.string  "attribute_name"
    t.string  "attribute_description"
    t.string  "attribute_data_type"
    t.decimal "count"
    t.decimal "n"
    t.decimal "n_percent",                       precision: 5, scale: 2
    t.decimal "mean"
    t.decimal "stddev"
    t.decimal "min"
    t.decimal "max"
    t.decimal "subset_count"
    t.decimal "subset_n"
    t.decimal "subset_n_percent",                precision: 5, scale: 2
    t.decimal "subset_mean"
    t.decimal "subset_stddev"
    t.decimal "subset_min"
    t.decimal "subset_max"
    t.decimal "ci_lower"
    t.decimal "ci_upper"
    t.decimal "subset_ci_lower"
    t.decimal "subset_ci_upper"
    t.boolean "is_continuous",                                           default: false, null: false
  end

  add_index "meta_attribute_statistics", ["subset_id", "entity_schema", "entity_name", "attribute_name"], name: "ix_meta_attribute_statistics", unique: true, using: :btree

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", force: :cascade do |t|
    t.integer "meta_attribute_statistic_id", limit: 8
    t.string  "subset_id"
    t.string  "entity_schema"
    t.string  "entity_name"
    t.string  "attribute_name"
    t.decimal "value"
    t.string  "value_description"
    t.decimal "count"
    t.decimal "subset_count"
  end

  add_index "meta_attribute_values", ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id", using: :btree
  add_index "meta_attribute_values", ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true, using: :btree

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", force: :cascade do |t|
    t.integer "meta_attribute_statistic_id", limit: 8
    t.string  "subset_id"
    t.string  "entity_schema"
    t.string  "entity_name"
    t.string  "attribute_name"
    t.decimal "value"
    t.string  "value_description"
    t.decimal "count"
    t.decimal "subset_count"
  end

  add_index "meta_attribute_values", ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id", using: :btree
  add_index "meta_attribute_values", ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true, using: :btree

  create_table "permission_groups", force: :cascade do |t|
    t.text     "title",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "pinned_survey_group_titles"
  end

  create_table "permission_ls_group_filters", force: :cascade do |t|
    t.integer  "permission_ls_group_id",                 null: false
    t.integer  "lime_question_qid"
    t.text     "ident_type"
    t.text     "restricted_val"
    t.boolean  "filter_all",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permission_ls_group_filters", ["permission_ls_group_id", "lime_question_qid"], name: "uniq_qid_by_group", unique: true, using: :btree

  create_table "permission_ls_groups", force: :cascade do |t|
    t.integer  "lime_survey_sid",                     null: false
    t.integer  "permission_group_id",                 null: false
    t.boolean  "enabled",             default: false
    t.boolean  "view_raw",            default: false
    t.boolean  "view_all",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permission_ls_groups", ["lime_survey_sid", "permission_group_id"], name: "uniq_sid_by_group", unique: true, using: :btree

  create_table "question_widgets", force: :cascade do |t|
    t.integer  "role_aggregate_id"
    t.integer  "lime_question_qid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agg",               limit: 255
    t.string   "pk",                limit: 255
    t.integer  "user_id"
    t.string   "graph_type",        limit: 255
    t.string   "view_type"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_aggregates", force: :cascade do |t|
    t.string   "pk_fieldname",        limit: 255
    t.integer  "lime_survey_sid"
    t.text     "agg_fieldname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pk_title_fieldname",  limit: 255
    t.string   "view_type",           limit: 255
    t.string   "pk_label",            limit: 255
    t.string   "agg_label",           limit: 255
    t.string   "agg_title_fieldname", limit: 255
    t.string   "default_view",        limit: 255
  end

  create_table "sources", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "sourceable_id"
    t.string   "sourceable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "sources", ["review_id"], name: "index_sources_on_review_id", using: :btree

  create_table "user_externals", force: :cascade do |t|
    t.integer "user_id"
    t.string  "ident",      limit: 255
    t.string  "ident_type", limit: 255
    t.boolean "use_email",              default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",      null: false
    t.string   "encrypted_password",     limit: 255, default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "p4_program_id"
    t.text     "roles"
    t.string   "full_name",              limit: 255
    t.string   "username",               limit: 255
    t.datetime "locked_at"
    t.boolean  "is_ldap",                            default: false
    t.integer  "permission_group_id"
    t.integer  "cohort_id"
    t.string   "ls_list_state",                      default: "dirty"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "version_notes", force: :cascade do |t|
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",       limit: 255, null: false
    t.integer  "item_id",                     null: false
    t.string   "event",           limit: 255, null: false
    t.string   "whodunnit",       limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "version_note_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["version_note_id"], name: "index_versions_on_version_note_id", using: :btree

  add_foreign_key "role_aggregates", "lime_surveys", column: "lime_survey_sid", primary_key: "sid", name: "lime_survey_sid_fk", on_delete: :cascade
end
