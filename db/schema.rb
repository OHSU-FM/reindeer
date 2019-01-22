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

ActiveRecord::Schema.define(version: 2019_01_16_150033) do

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

  create_table "artifacts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_artifacts_on_user_id"
  end

  create_table "assignment_comments", id: :serial, force: :cascade do |t|
    t.integer "user_assignment_id"
    t.integer "user_id"
    t.text "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assignment_group_id"
    t.index ["assignment_group_id"], name: "index_assignment_comments_on_assignment_group_id"
    t.index ["user_assignment_id"], name: "index_assignment_comments_on_user_assignment_id"
    t.index ["user_id"], name: "index_assignment_comments_on_user_id"
  end

  create_table "assignment_group_templates", id: :serial, force: :cascade do |t|
    t.integer "permission_group_id"
    t.string "title"
    t.text "permission_group_ids"
    t.text "sids"
    t.text "desc_md"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_group_id"], name: "index_assignment_group_templates_on_permission_group_id"
  end

  create_table "assignment_groups", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "assignment_group_template_id"
    t.string "title"
    t.integer "status"
    t.text "desc_md"
    t.text "user_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_group_template_id"], name: "index_assignment_groups_on_assignment_group_template_id"
    t.index ["user_id"], name: "index_assignment_groups_on_user_id"
  end

  create_table "chart_series", id: :serial, force: :cascade do |t|
    t.integer "chart_id"
    t.text "group_filter"
    t.text "entity_filter"
    t.text "category_filter"
    t.text "question_filter"
    t.text "question_options_filter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chart_id"], name: "index_chart_series_on_chart_id"
  end

  create_table "charts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "title"
    t.text "output"
    t.text "chart_type"
    t.text "aggregator_type"
    t.text "cols"
    t.text "rows"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_charts_on_user_id"
  end

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_group_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_group_id"], name: "index_cohorts_on_permission_group_id"
    t.index ["user_id"], name: "index_cohorts_on_user_id"
  end

  create_table "competencies", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "student_uid"
    t.string "student_name"
    t.string "email"
    t.string "student_year"
    t.decimal "ics", precision: 5, scale: 2
    t.decimal "mk", precision: 5, scale: 2
    t.decimal "pbli", precision: 5, scale: 2
    t.decimal "pcp", precision: 5, scale: 2
    t.decimal "pppd", precision: 5, scale: 2
    t.decimal "sbpic", precision: 5, scale: 2
    t.decimal "ics1", precision: 5, scale: 2
    t.decimal "ics2", precision: 5, scale: 2
    t.decimal "ics3", precision: 5, scale: 2
    t.decimal "ics4", precision: 5, scale: 2
    t.decimal "ics5", precision: 5, scale: 2
    t.decimal "ics6", precision: 5, scale: 2
    t.decimal "ics7", precision: 5, scale: 2
    t.decimal "ics8", precision: 5, scale: 2
    t.decimal "mk1", precision: 5, scale: 2
    t.decimal "mk2", precision: 5, scale: 2
    t.decimal "mk3", precision: 5, scale: 2
    t.decimal "mk4", precision: 5, scale: 2
    t.decimal "mk5", precision: 5, scale: 2
    t.decimal "pbli1", precision: 5, scale: 2
    t.decimal "pbli2", precision: 5, scale: 2
    t.decimal "pbli3", precision: 5, scale: 2
    t.decimal "pbli4", precision: 5, scale: 2
    t.decimal "pbli5", precision: 5, scale: 2
    t.decimal "pbli6", precision: 5, scale: 2
    t.decimal "pbli7", precision: 5, scale: 2
    t.decimal "pbli8", precision: 5, scale: 2
    t.decimal "pcp1", precision: 5, scale: 2
    t.decimal "pcp2", precision: 5, scale: 2
    t.decimal "pcp3", precision: 5, scale: 2
    t.decimal "pcp4", precision: 5, scale: 2
    t.decimal "pcp5", precision: 5, scale: 2
    t.decimal "pcp6", precision: 5, scale: 2
    t.decimal "pppd1", precision: 5, scale: 2
    t.decimal "pppd2", precision: 5, scale: 2
    t.decimal "pppd3", precision: 5, scale: 2
    t.decimal "pppd4", precision: 5, scale: 2
    t.decimal "pppd5", precision: 5, scale: 2
    t.decimal "pppd6", precision: 5, scale: 2
    t.decimal "pppd7", precision: 5, scale: 2
    t.decimal "pppd8", precision: 5, scale: 2
    t.decimal "pppd9", precision: 5, scale: 2
    t.decimal "pppd10", precision: 5, scale: 2
    t.decimal "pppd11", precision: 5, scale: 2
    t.decimal "sbpic1", precision: 5, scale: 2
    t.decimal "sbpic2", precision: 5, scale: 2
    t.decimal "sbpic3", precision: 5, scale: 2
    t.decimal "sbpic4", precision: 5, scale: 2
    t.decimal "sbpic5", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_uid"], name: "index_competencies_on_student_uid"
    t.index ["user_id"], name: "index_competencies_on_user_id"
  end

  create_table "content_slugs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.boolean "public"
    t.integer "sizex"
    t.integer "sizey"
    t.boolean "resizeable", default: true
  end

  create_table "critical_values", primary_key: ["alpha", "df"], force: :cascade do |t|
    t.integer "df", null: false
    t.decimal "t", null: false
    t.decimal "alpha", default: "0.05", null: false
  end

  create_table "dashboard_widgets", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "position"
    t.integer "sizex"
    t.integer "sizey"
    t.boolean "resizeable", default: true
    t.text "widget_type"
    t.integer "widget_id"
    t.string "widget_title", limit: 255
  end

  create_table "dashboards", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "theme"
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "data_migrations", id: :serial, force: :cascade do |t|
    t.text "version", null: false
  end

  create_table "epas", force: :cascade do |t|
    t.datetime "submit_date"
    t.string "student_assessed"
    t.string "epa"
    t.string "clinical_discipline"
    t.string "clinical_setting"
    t.string "clinical_assessor"
    t.string "assessor_name"
    t.string "no_of_times_with_super"
    t.integer "involvement"
    t.string "more_independent"
    t.boolean "encounter_complex"
    t.string "assessor_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "response_id"
    t.index ["response_id"], name: "index_epas_on_response_id"
    t.index ["user_id"], name: "index_epas_on_user_id"
  end

  create_table "goals", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "g_status"
    t.string "competency_tag"
    t.datetime "target_date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.datetime "date"
    t.string "location"
    t.string "m_status"
    t.text "notes"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "content"
    t.boolean "archived", default: false
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "meta_attribute_entities", id: :serial, force: :cascade do |t|
    t.text "entity_type", null: false
    t.text "meta_attribute_entity_group_group_name", null: false
    t.integer "edition"
    t.integer "version"
    t.date "start_date"
    t.date "stop_date"
    t.boolean "visible", default: true
    t.integer "reference_year"
    t.string "entity_type_fk", limit: 255
    t.index ["entity_type"], name: "ix_meta_attribute_entities", unique: true
  end

  create_table "meta_attribute_entity_groups", id: :serial, force: :cascade do |t|
    t.text "group_name", null: false
    t.text "parent_table", null: false
    t.boolean "visible", default: true
    t.string "parent_table_pk", limit: 255
  end

  create_table "meta_attribute_groups", id: :serial, force: :cascade do |t|
    t.text "group_name", null: false
    t.text "parent_table", null: false
    t.boolean "visible", default: true
  end

  create_table "meta_attribute_questions", id: :serial, force: :cascade do |t|
    t.text "meta_attribute_entity_entity_type", null: false
    t.text "category"
    t.text "attribute_name"
    t.text "description"
    t.text "original_text"
    t.text "data_type"
    t.text "options_hash"
    t.boolean "continuous"
    t.boolean "optional"
    t.boolean "visible", default: true
    t.text "short_name"
  end

  create_table "meta_attribute_statistics", primary_key: "meta_attribute_statistic_id", id: :bigint, default: nil, force: :cascade do |t|
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.bigint "attribute_index"
    t.string "attribute_name"
    t.string "attribute_description"
    t.string "attribute_data_type"
    t.decimal "count"
    t.decimal "n"
    t.decimal "n_percent", precision: 5, scale: 2
    t.decimal "mean"
    t.decimal "stddev"
    t.decimal "min"
    t.decimal "max"
    t.decimal "subset_count"
    t.decimal "subset_n"
    t.decimal "subset_n_percent", precision: 5, scale: 2
    t.decimal "subset_mean"
    t.decimal "subset_stddev"
    t.decimal "subset_min"
    t.decimal "subset_max"
    t.decimal "ci_lower"
    t.decimal "ci_upper"
    t.decimal "subset_ci_lower"
    t.decimal "subset_ci_upper"
    t.boolean "is_continuous", default: false, null: false
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name"], name: "ix_meta_attribute_statistics", unique: true
  end

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "meta_attribute_statistic_id"
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.string "attribute_name"
    t.decimal "value"
    t.string "value_description"
    t.decimal "count"
    t.decimal "subset_count"
    t.index ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true
  end

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "meta_attribute_statistic_id"
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.string "attribute_name"
    t.decimal "value"
    t.string "value_description"
    t.decimal "count"
    t.decimal "subset_count"
    t.index ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true
  end

  create_table "permission_groups", id: :serial, force: :cascade do |t|
    t.text "title", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "pinned_survey_group_titles"
  end

  create_table "permission_ls_group_filters", id: :serial, force: :cascade do |t|
    t.integer "permission_ls_group_id", null: false
    t.integer "lime_question_qid"
    t.text "ident_type"
    t.text "restricted_val"
    t.boolean "filter_all", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["permission_ls_group_id", "lime_question_qid"], name: "uniq_qid_by_group", unique: true
  end

  create_table "permission_ls_groups", id: :serial, force: :cascade do |t|
    t.integer "lime_survey_sid", null: false
    t.integer "permission_group_id", null: false
    t.boolean "enabled", default: false
    t.boolean "view_raw", default: false
    t.boolean "view_all", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["lime_survey_sid", "permission_group_id"], name: "uniq_sid_by_group", unique: true
  end

  create_table "question_widgets", id: :serial, force: :cascade do |t|
    t.integer "role_aggregate_id"
    t.integer "lime_question_qid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "agg", limit: 255
    t.string "pk", limit: 255
    t.integer "user_id"
    t.string "graph_type", limit: 255
    t.string "view_type"
  end

  create_table "role_aggregates", id: :serial, force: :cascade do |t|
    t.string "pk_fieldname", limit: 255
    t.integer "lime_survey_sid"
    t.text "agg_fieldname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "pk_title_fieldname", limit: 255
    t.string "view_type", limit: 255
    t.string "pk_label", limit: 255
    t.string "agg_label", limit: 255
    t.string "agg_title_fieldname", limit: 255
    t.string "default_view", limit: 255
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discussable_id"
    t.string "discussable_type"
  end

  create_table "survey_assignments", id: :serial, force: :cascade do |t|
    t.boolean "as_inline", default: false
    t.string "title"
    t.integer "lime_survey_sid", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["lime_survey_sid"], name: "index_survey_assignments_on_lime_survey_sid"
  end

  create_table "user_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "survey_assignment_id", null: false
    t.integer "lime_token_tid"
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_externals", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "ident", limit: 255
    t.string "ident_type", limit: 255
    t.boolean "use_email", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "p4_program_id"
    t.text "roles"
    t.string "full_name", limit: 255
    t.string "username", limit: 255
    t.datetime "locked_at"
    t.boolean "is_ldap", default: false
    t.integer "permission_group_id"
    t.integer "cohort_id"
    t.string "ls_list_state", default: "dirty"
    t.string "coaching_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "version_notes", id: :serial, force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "version_note_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["version_note_id"], name: "index_versions_on_version_note_id"
  end

  add_foreign_key "artifacts", "users"
  add_foreign_key "assignment_comments", "assignment_groups"
  add_foreign_key "assignment_comments", "user_assignments"
  add_foreign_key "assignment_comments", "users"
  add_foreign_key "assignment_groups", "assignment_group_templates"
  add_foreign_key "assignment_groups", "users"
  add_foreign_key "cohorts", "users"
  add_foreign_key "epas", "users"
  add_foreign_key "role_aggregates", "lime_surveys", column: "lime_survey_sid", primary_key: "sid", name: "lime_survey_sid_fk", on_delete: :cascade
  add_foreign_key "survey_assignments", "lime_surveys", column: "lime_survey_sid", primary_key: "sid", on_delete: :cascade
  add_foreign_key "user_assignments", "survey_assignments", on_delete: :cascade
end
