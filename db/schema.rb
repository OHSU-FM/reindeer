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

ActiveRecord::Schema[7.0].define(version: 2023_07_11_152627) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advisors", force: :cascade do |t|
    t.string "advisor_type"
    t.string "name"
    t.string "email"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
    t.string "specialty"
  end

  create_table "artifacts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_artifacts_on_user_id"
  end

  create_table "chart_series", id: :serial, force: :cascade do |t|
    t.integer "chart_id"
    t.text "group_filter"
    t.text "entity_filter"
    t.text "category_filter"
    t.text "question_filter"
    t.text "question_options_filter"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["user_id"], name: "index_charts_on_user_id"
  end

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_group_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["permission_group_id"], name: "index_cohorts_on_permission_group_id"
    t.index ["user_id"], name: "index_cohorts_on_user_id"
  end

  create_table "competencies", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "permission_group_id"
    t.string "student_uid"
    t.string "email"
    t.string "medhub_id"
    t.string "course_name"
    t.string "course_id"
    t.date "start_date"
    t.date "end_date"
    t.date "submit_date"
    t.string "evaluator"
    t.string "final_grade"
    t.string "environment"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.text "prof_concerns"
    t.text "comm_prof_concerns"
    t.text "overall_summ_comm_perf"
    t.text "add_comm_on_perform"
    t.text "mspe"
    t.text "clinic_exp_comment"
    t.text "feedback"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["permission_group_id"], name: "index_competencies_on_permission_group_id"
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

  create_table "courses", force: :cascade do |t|
    t.string "competency_code"
    t.string "course_no"
    t.string "course_name"
    t.string "department"
    t.text "course_purpose_statement"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["competency_code", "course_no"], name: "index_courses_on_competency_code_and_course_no", unique: true
  end

  create_table "cpxes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "email"
    t.string "full_name"
    t.json "cpx_data"
    t.index ["email"], name: "index_cpxes_on_email", unique: true
    t.index ["user_id"], name: "index_cpxes_on_user_id"
  end

  create_table "critical_values", primary_key: ["alpha", "df"], force: :cascade do |t|
    t.integer "df", null: false
    t.decimal "t", null: false
    t.decimal "alpha", default: "0.05", null: false
    t.check_constraint "df >= 1", name: "critical_values_df_check"
  end

  create_table "csl_evals", force: :cascade do |t|
    t.bigint "user_id"
    t.string "csl_title"
    t.date "submit_date"
    t.string "cohorts"
    t.string "instructor"
    t.string "selected_student"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c5"
    t.integer "c6"
    t.integer "c7"
    t.integer "c8"
    t.integer "c9"
    t.text "feedback"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_csl_evals_on_user_id"
  end

  create_table "csl_feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "csl_title"
    t.date "submit_date"
    t.string "cohorts"
    t.string "instructor"
    t.string "selected_student"
    t.string "c1"
    t.string "c1_feedback"
    t.string "c2"
    t.string "c2_feedback"
    t.text "feedback_strength"
    t.text "feedback_improve"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "response_id"
    t.index ["response_id"], name: "index_csl_feedbacks_on_response_id", unique: true
    t.index ["user_id"], name: "index_csl_feedbacks_on_user_id"
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

  create_table "eg_cohorts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.string "email"
    t.string "eg_full_name1"
    t.string "eg_email1"
    t.string "eg_full_name2"
    t.string "eg_email2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_eg_cohorts_on_user_id"
  end

  create_table "eg_members", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "eg_type"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eg_reasons", force: :cascade do |t|
    t.string "reason"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "epa_masters", force: :cascade do |t|
    t.string "epa"
    t.string "status"
    t.datetime "status_date", precision: nil
    t.datetime "expiration_date", precision: nil
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "epa"], name: "by_user_epas", unique: true
    t.index ["user_id"], name: "index_epa_masters_on_user_id"
  end

  create_table "epa_reviews", force: :cascade do |t|
    t.string "epa"
    t.datetime "review_date1", precision: nil
    t.string "reviewer1"
    t.string "badge_decision1"
    t.string "trust1"
    t.text "evidence1"
    t.text "general_comments1"
    t.datetime "review_date2", precision: nil
    t.string "reviewer2"
    t.string "badge_decision2"
    t.string "trust2"
    t.text "evidence2"
    t.text "general_comments2"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "reason1"
    t.string "reason2"
    t.string "student_comments1"
    t.string "student_comments2"
    t.index ["epa", "id"], name: "by_epa_reviews", unique: true
    t.index ["reviewable_type", "reviewable_id"], name: "index_epa_reviews_on_reviewable_type_and_reviewable_id"
  end

  create_table "epas", force: :cascade do |t|
    t.datetime "submit_date", precision: nil
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.string "response_id"
    t.boolean "attending_faculty"
    t.string "other_role"
    t.index ["response_id"], name: "index_epas_on_response_id"
    t.index ["user_id"], name: "index_epas_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.integer "advisor_id"
    t.index ["advisor_id", "id"], name: "index_events_on_advisor_id_and_id", unique: true
    t.index ["user_id", "id"], name: "index_events_on_user_id_and_id"
  end

  create_table "fileupload_settings", force: :cascade do |t|
    t.integer "permission_group_id"
    t.string "code"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_group_id", "code"], name: "index_fileupload_settings_on_permission_group_id_and_code", unique: true
  end

  create_table "fom_exams", force: :cascade do |t|
    t.string "course_code"
    t.datetime "submit_date", precision: nil
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_dropped_score"
    t.string "comp1_dropped_quiz"
    t.decimal "comp2a_hss1"
    t.decimal "comp2a_hss2"
    t.decimal "comp2a_hss3"
    t.decimal "comp2a_hss4"
    t.decimal "comp2a_hss5"
    t.decimal "comp2a_hss6"
    t.decimal "comp2a_hssavg"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp2b_bssavg"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hssavg"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bssavg"
    t.decimal "summary_comp1"
    t.decimal "summary_comp2a"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "permission_group_id"
    t.decimal "comp2a_hss7"
    t.decimal "comp2b_bss10"
    t.decimal "comp2b_bss11"
    t.decimal "comp2b_bss12"
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_user_permission_group_course_code", unique: true
    t.index ["user_id"], name: "index_fom_exams_on_user_id"
  end

  create_table "fom_labels", force: :cascade do |t|
    t.integer "permission_group_id"
    t.string "course_code"
    t.json "labels"
    t.boolean "block_enabled"
    t.index ["permission_group_id", "course_code"], name: "by_permission_group_course_code", unique: true
  end

  create_table "fom_remeds", force: :cascade do |t|
    t.integer "user_id"
    t.string "block"
    t.string "component_failed"
    t.string "component_desc"
    t.decimal "initial_test_result"
    t.string "areas_of_deficiency"
    t.decimal "re_test_result"
    t.string "passed_failed"
    t.integer "prev_comp_failures"
    t.integer "no_of_failures_to_date"
    t.string "acad_probation"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fom_remeds_on_user_id"
  end

  create_table "formative_feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "block_code"
    t.string "csa_code"
    t.string "response_id"
    t.date "submit_date"
    t.string "q1"
    t.string "q2"
    t.string "q3"
    t.string "q4"
    t.string "q5"
    t.string "q6"
    t.string "q7"
    t.string "q8"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["response_id"], name: "index_formative_feedbacks_on_response_id"
    t.index ["user_id"], name: "index_formative_feedbacks_on_user_id"
  end

  create_table "goals", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "g_status"
    t.string "competency_tag"
    t.datetime "target_date", precision: nil
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "ipe_courses", primary_key: "course_id", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "course_code", limit: 20, null: false
    t.string "course_name", limit: 100
    t.index ["course_code"], name: "ipe_courses_course_code", unique: true
  end

  create_table "med18_competencies", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "permission_group_id"
    t.string "student_uid"
    t.string "email"
    t.string "medhub_id"
    t.string "course_name"
    t.string "course_id"
    t.date "start_date"
    t.date "end_date"
    t.date "submit_date"
    t.string "evaluator"
    t.string "final_grade"
    t.string "environment"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.text "prof_concerns"
    t.text "comm_prof_concerns"
    t.text "overall_summ_comm_perf"
    t.text "add_comm_on_perform"
    t.text "mspe"
    t.text "clinic_exp_comment"
    t.text "feedback"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.index ["permission_group_id"], name: "index_med18_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med18_competencies_on_user_id"
  end

  create_table "med18_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med18_mspe_email_key", unique: true
  end

  create_table "med19_competencies", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.string "student_uid"
    t.string "email"
    t.string "medhub_id"
    t.string "course_name"
    t.string "course_id"
    t.date "start_date"
    t.date "end_date"
    t.date "submit_date"
    t.string "evaluator"
    t.string "final_grade"
    t.string "environment"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.text "prof_concerns"
    t.text "comm_prof_concerns"
    t.text "overall_summ_comm_perf"
    t.text "add_comm_on_perform"
    t.text "mspe"
    t.text "clinic_exp_comment"
    t.text "feedback"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.index ["permission_group_id"], name: "index_med19_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med19_competencies_on_user_id"
  end

  create_table "med19_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med19_mspe_email_key", unique: true
  end

  create_table "med20_competencies", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.string "student_uid"
    t.string "email"
    t.string "medhub_id"
    t.string "course_name"
    t.string "course_id"
    t.date "start_date"
    t.date "end_date"
    t.date "submit_date"
    t.string "evaluator"
    t.string "final_grade"
    t.string "environment"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.text "prof_concerns"
    t.text "comm_prof_concerns"
    t.text "overall_summ_comm_perf"
    t.text "add_comm_on_perform"
    t.text "mspe"
    t.text "clinic_exp_comment"
    t.text "feedback"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.index ["permission_group_id"], name: "index_med20_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med20_competencies_on_user_id"
  end

  create_table "med20_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med20_mspe_email_key", unique: true
  end

  create_table "med21_competencies", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.string "student_uid"
    t.string "email"
    t.string "medhub_id"
    t.string "course_name"
    t.string "course_id"
    t.date "start_date"
    t.date "end_date"
    t.date "submit_date"
    t.string "evaluator"
    t.string "final_grade"
    t.string "environment"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.text "prof_concerns"
    t.text "comm_prof_concerns"
    t.text "overall_summ_comm_perf"
    t.text "add_comm_on_perform"
    t.text "mspe"
    t.text "clinic_exp_comment"
    t.text "feedback"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.index ["permission_group_id"], name: "index_med21_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med21_competencies_on_user_id"
  end

  create_table "med21_fom_exams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_group_id"
    t.string "course_code"
    t.datetime "submit_date", precision: nil
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_dropped_score"
    t.string "comp1_dropped_quiz"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp2b_bss10"
    t.decimal "comp2b_bss11"
    t.decimal "comp2b_bss12"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hss4"
    t.decimal "comp5a_hss5"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bss6"
    t.decimal "comp5b_bss7"
    t.decimal "summary_comp1"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_med21_user_permission_group_course_code", unique: true
  end

  create_table "med21_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med21_mspe_email_key", unique: true
  end

  create_table "med22_fom_exams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_group_id"
    t.string "course_code"
    t.datetime "submit_date", precision: nil
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_dropped_score"
    t.string "comp1_dropped_quiz"
    t.decimal "comp2a_hss1"
    t.decimal "comp2a_hss2"
    t.decimal "comp2a_hss3"
    t.decimal "comp2a_hss4"
    t.decimal "comp2a_hss5"
    t.decimal "comp2a_hss6"
    t.decimal "comp2a_hss7"
    t.decimal "comp2a_hssavg"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp2b_bssavg"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hssavg"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bssavg"
    t.decimal "summary_comp1"
    t.decimal "summary_comp2a"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "comp5a_hss4"
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_med22_user_permission_group_course_code", unique: true
  end

  create_table "med22_mspe_cces", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med22_mspe_cces_email_key", unique: true
  end

  create_table "med22_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med22_mspe_email_key", unique: true
  end

  create_table "med23_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.index ["email"], name: "med23_mspe_email_key", unique: true
    t.index ["user_id"], name: "index_med23_mspes_on_user_id"
  end

  create_table "med24_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.index ["email"], name: "med24_mspe_email_key", unique: true
  end

  create_table "medhub_period_ids", id: false, force: :cascade do |t|
    t.integer "courseID"
    t.integer "periodID"
    t.date "start_date"
    t.date "end_date"
    t.index ["courseID", "periodID"], name: "medhub_period_ids_idx"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.string "subject", array: true
    t.datetime "date", precision: nil
    t.string "location"
    t.string "m_status"
    t.text "notes"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "advisor_type"
    t.integer "advisor_id"
    t.integer "event_id"
    t.string "advice_category"
    t.text "advisor_discussed", default: [], array: true
    t.text "advisor_outcomes", default: [], array: true
    t.string "academic_discussed_other"
    t.string "academic_outcomes_other"
    t.string "career_discussed_other"
    t.string "career_outcomes_other"
    t.text "advisor_notes"
    t.text "study_resources", default: [], array: true
    t.string "study_resources_other"
    t.json "nbme_form"
    t.json "uworld_info"
    t.json "qbank_info"
    t.index ["advisor_id", "id"], name: "index_meetings_on_advisor_id_and_id", unique: true
    t.index ["event_id", "id"], name: "index_meetings_on_event_id_and_id", unique: true
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "content"
    t.boolean "archived", default: false
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "pinned_survey_group_titles"
  end

  create_table "permission_ls_group_filters", id: :serial, force: :cascade do |t|
    t.integer "permission_ls_group_id", null: false
    t.integer "lime_question_qid"
    t.text "ident_type"
    t.text "restricted_val"
    t.boolean "filter_all", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["permission_ls_group_id", "lime_question_qid"], name: "uniq_qid_by_group", unique: true
  end

  create_table "permission_ls_groups", id: :serial, force: :cascade do |t|
    t.integer "lime_survey_sid", null: false
    t.integer "permission_group_id", null: false
    t.boolean "enabled", default: false
    t.boolean "view_raw", default: false
    t.boolean "view_all", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["lime_survey_sid", "permission_group_id"], name: "uniq_sid_by_group", unique: true
  end

  create_table "preceptor_assesses", force: :cascade do |t|
    t.bigint "user_id"
    t.string "response_id"
    t.string "preceptor_name"
    t.string "preceptor_email"
    t.date "submit_date"
    t.string "term"
    t.string "grade"
    t.boolean "attribute1"
    t.text "attribute1_no"
    t.boolean "attribute2"
    t.text "attribute2_no"
    t.boolean "attribute3"
    t.text "attribute3_no"
    t.text "overall_performance"
    t.text "feedback"
    t.string "professional_concerns"
    t.string "concern_comments"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["response_id"], name: "index_preceptor_assesses_on_response_id"
    t.index ["user_id"], name: "index_preceptor_assesses_on_user_id"
  end

  create_table "preceptor_evals", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission_group_id"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "pbli1", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd9", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.string "preceptor_name"
    t.date "submit_date"
    t.string "term"
    t.string "grade"
    t.string "professional_concerns"
    t.string "concern_comments"
    t.text "mspe_comments"
    t.text "comments"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "permission_group_id"], name: "by_user_permission_group_id"
    t.index ["user_id"], name: "index_preceptor_evals_on_user_id"
  end

  create_table "question_widgets", id: :serial, force: :cascade do |t|
    t.integer "role_aggregate_id"
    t.integer "lime_question_qid"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "pk_title_fieldname", limit: 255
    t.string "view_type", limit: 255
    t.string "pk_label", limit: 255
    t.string "agg_label", limit: 255
    t.string "agg_title_fieldname", limit: 255
    t.string "default_view", limit: 255
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "discussable_id"
    t.string "discussable_type"
  end

  create_table "ume_blses", force: :cascade do |t|
    t.bigint "user_id"
    t.date "expiration_date"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ume_blses_on_user_id"
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
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "p4_program_id"
    t.text "roles"
    t.string "full_name", limit: 255
    t.string "username", limit: 255
    t.datetime "locked_at", precision: nil
    t.boolean "is_ldap", default: false
    t.integer "permission_group_id"
    t.integer "cohort_id"
    t.string "ls_list_state", default: "dirty"
    t.string "coaching_type"
    t.integer "prev_permission_group_id"
    t.string "spec_program"
    t.string "sid"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.boolean "subscribed", default: false, null: false
    t.date "matriculated_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sid"], name: "index_users_on_sid", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "usmle_exams", force: :cascade do |t|
    t.bigint "user_id"
    t.string "exam_type"
    t.integer "no_attempts"
    t.string "pass_fail"
    t.integer "exam_score"
    t.datetime "exam_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_usmle_exams_on_user_id"
  end

  create_table "version_notes", id: :serial, force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.integer "version_note_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["version_note_id"], name: "index_versions_on_version_note_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artifacts", "users"
  add_foreign_key "cohorts", "users"
  add_foreign_key "competencies", "permission_groups"
  add_foreign_key "competencies", "users"
  add_foreign_key "csl_evals", "users"
  add_foreign_key "csl_feedbacks", "users"
  add_foreign_key "eg_cohorts", "users"
  add_foreign_key "epa_masters", "users"
  add_foreign_key "epas", "users"
  add_foreign_key "fom_exams", "users"
  add_foreign_key "formative_feedbacks", "users"
  add_foreign_key "med18_competencies", "permission_groups"
  add_foreign_key "med19_competencies", "permission_groups"
  add_foreign_key "med20_competencies", "permission_groups"
  add_foreign_key "med21_competencies", "permission_groups"
  add_foreign_key "med23_mspes", "users"
  add_foreign_key "preceptor_assesses", "users"
  add_foreign_key "preceptor_evals", "users"
  add_foreign_key "usmle_exams", "users"
end
