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

ActiveRecord::Schema.define(version: 20151017235330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignment_comments", force: :cascade do |t|
    t.integer  "user_assignment_id"
    t.integer  "user_id"
    t.text     "slug"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "assignment_comments", ["user_assignment_id"], name: "index_assignment_comments_on_user_assignment_id", using: :btree
  add_index "assignment_comments", ["user_id"], name: "index_assignment_comments_on_user_id", using: :btree

  create_table "assignment_group_templates", force: :cascade do |t|
    t.integer  "permission_group_id"
    t.string   "title"
    t.text     "sids"
    t.text     "desc_md"
    t.boolean  "active",              default: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "assignment_group_templates", ["permission_group_id"], name: "index_assignment_group_templates_on_permission_group_id", using: :btree

  create_table "assignment_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assignment_group_template_id"
    t.string   "title"
    t.integer  "status"
    t.text     "desc_md"
    t.text     "user_ids"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "assignment_groups", ["assignment_group_template_id"], name: "index_assignment_groups_on_assignment_group_template_id", using: :btree
  add_index "assignment_groups", ["user_id"], name: "index_assignment_groups_on_user_id", using: :btree

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

  create_table "lime_answers", id: false, force: :cascade do |t|
    t.integer "qid",                         default: 0,    null: false
    t.string  "code",             limit: 5,  default: "",   null: false
    t.text    "answer",                                     null: false
    t.integer "sortorder",                                  null: false
    t.string  "language",         limit: 20, default: "en", null: false
    t.integer "assessment_value",            default: 0,    null: false
    t.integer "scale_id",                    default: 0,    null: false
  end

  add_index "lime_answers", ["sortorder"], name: "answers_idx2", using: :btree

  create_table "lime_assessments", id: false, force: :cascade do |t|
    t.integer "id",                  default: "nextval('lime_assessments_id_seq'::regclass)", null: false
    t.integer "sid",                 default: 0,                                              null: false
    t.string  "scope",    limit: 5,  default: "",                                             null: false
    t.integer "gid",                 default: 0,                                              null: false
    t.text    "name",                                                                         null: false
    t.string  "minimum",  limit: 50, default: "",                                             null: false
    t.string  "maximum",  limit: 50, default: "",                                             null: false
    t.text    "message",                                                                      null: false
    t.string  "language", limit: 20, default: "en",                                           null: false
  end

  add_index "lime_assessments", ["gid"], name: "assessments_idx3", using: :btree
  add_index "lime_assessments", ["sid"], name: "assessments_idx2", using: :btree

  create_table "lime_conditions", primary_key: "cid", force: :cascade do |t|
    t.integer "qid",                    default: 0,  null: false
    t.integer "cqid",                   default: 0,  null: false
    t.string  "cfieldname", limit: 50,  default: "", null: false
    t.string  "method",     limit: 5,   default: "", null: false
    t.string  "value",      limit: 255, default: "", null: false
    t.integer "scenario",               default: 1,  null: false
  end

  add_index "lime_conditions", ["cqid"], name: "conditions_idx3", using: :btree
  add_index "lime_conditions", ["qid"], name: "conditions_idx2", using: :btree

  create_table "lime_defaultvalues", id: false, force: :cascade do |t|
    t.integer "qid",                     default: 0,  null: false
    t.integer "scale_id",                default: 0,  null: false
    t.integer "sqid",                    default: 0,  null: false
    t.string  "language",     limit: 20,              null: false
    t.string  "specialtype",  limit: 20, default: "", null: false
    t.text    "defaultvalue"
  end

  create_table "lime_expression_errors", force: :cascade do |t|
    t.string  "errortime",   limit: 50
    t.integer "sid"
    t.integer "gid"
    t.integer "qid"
    t.integer "gseq"
    t.integer "qseq"
    t.string  "type",        limit: 50
    t.text    "eqn"
    t.text    "prettyprint"
  end

  create_table "lime_failed_login_attempts", force: :cascade do |t|
    t.string  "ip",              limit: 40, null: false
    t.string  "last_attempt",    limit: 20, null: false
    t.integer "number_attempts",            null: false
  end

  create_table "lime_groups", id: false, force: :cascade do |t|
    t.integer "gid",                             default: "nextval('lime_groups_gid_seq'::regclass)", null: false
    t.integer "sid",                             default: 0,                                          null: false
    t.string  "group_name",          limit: 100, default: "",                                         null: false
    t.integer "group_order",                     default: 0,                                          null: false
    t.text    "description"
    t.string  "language",            limit: 20,  default: "en",                                       null: false
    t.string  "randomization_group", limit: 20,  default: "",                                         null: false
    t.text    "grelevance"
  end

  add_index "lime_groups", ["sid"], name: "groups_idx2", using: :btree

  create_table "lime_labels", id: false, force: :cascade do |t|
    t.integer "lid",                         default: 0,    null: false
    t.string  "code",             limit: 5,  default: "",   null: false
    t.text    "title"
    t.integer "sortorder",                                  null: false
    t.integer "assessment_value",            default: 0,    null: false
    t.string  "language",         limit: 20, default: "en", null: false
  end

  add_index "lime_labels", ["code"], name: "labels_code_idx", using: :btree

  create_table "lime_labelsets", primary_key: "lid", force: :cascade do |t|
    t.string "label_name", limit: 100, default: "",   null: false
    t.string "languages",  limit: 200, default: "en"
  end

  create_table "lime_old_survey_224436_20150402145228", force: :cascade do |t|
    t.string   "token",          limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",  limit: 20,                            null: false
    t.string   "224436X64X1056", limit: 255
    t.string   "224436X64X1067", limit: 255
    t.string   "224436X64X1068", limit: 255
    t.string   "224436X64X1069", limit: 255
    t.string   "224436X64X1070", limit: 255
    t.string   "224436X64X1057", limit: 5
    t.string   "224436X64X1058", limit: 5
    t.string   "224436X64X1059", limit: 255
    t.decimal  "224436X64X1060",             precision: 30, scale: 10
    t.string   "224436X64X1061", limit: 5
    t.decimal  "224436X64X1062",             precision: 30, scale: 10
    t.decimal  "224436X64X1063",             precision: 30, scale: 10
    t.string   "224436X64X1064", limit: 1
    t.string   "224436X64X1065", limit: 1
    t.datetime "224436X64X1066"
  end

  add_index "lime_old_survey_224436_20150402145228", ["token"], name: "idx_survey_token_224436_34", using: :btree

  create_table "lime_old_survey_224436_20150615090535", force: :cascade do |t|
    t.string   "token",          limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",  limit: 20,                            null: false
    t.string   "224436X64X1056", limit: 255
    t.string   "224436X64X1067", limit: 255
    t.string   "224436X64X1068", limit: 255
    t.string   "224436X64X1069", limit: 255
    t.string   "224436X64X1070", limit: 255
    t.string   "224436X64X1057", limit: 5
    t.string   "224436X64X1058", limit: 5
    t.string   "224436X64X1059", limit: 255
    t.decimal  "224436X64X1060",             precision: 30, scale: 10
    t.string   "224436X64X1061", limit: 5
    t.decimal  "224436X64X1062",             precision: 30, scale: 10
    t.decimal  "224436X64X1063",             precision: 30, scale: 10
    t.string   "224436X64X1064", limit: 255
  end

  add_index "lime_old_survey_224436_20150615090535", ["token"], name: "idx_survey_token_224436_15076", using: :btree

  create_table "lime_old_survey_237826_20150123091000", force: :cascade do |t|
    t.string   "token",                         limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                 limit: 20,                            null: false
    t.text     "237826X44X500StudentEmail"
    t.text     "237826X44X500StudentName"
    t.text     "237826X44X500CoachEmail"
    t.text     "237826X44X500CoachName"
    t.text     "237826X42X530CourseYear"
    t.text     "237826X42X530CourseName"
    t.decimal  "237826X42X478Week1MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week2MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week3MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week4MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week5MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week6MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X42X478Week7MCQ",                     precision: 30, scale: 10
    t.text     "237826X42X496DroppedQuiz"
    t.text     "237826X42X496DroppedScore"
    t.string   "237826X42X487",                 limit: 255
    t.decimal  "237826X42X488",                             precision: 30, scale: 10
    t.decimal  "237826X42X489",                             precision: 30, scale: 10
    t.decimal  "237826X42X490OSCE1",                        precision: 30, scale: 10
    t.decimal  "237826X42X490OSCE2",                        precision: 30, scale: 10
    t.decimal  "237826X42X490HistologySkills",              precision: 30, scale: 10
    t.decimal  "237826X42X490GeneticsPedigree",             precision: 30, scale: 10
    t.text     "237826X45X534CourseYear"
    t.text     "237826X45X534CourseName"
    t.decimal  "237826X45X506Week1MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X45X506Week2MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X45X506Week3MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X45X506Week4MCQ",                     precision: 30, scale: 10
    t.decimal  "237826X45X506Week5MCQ",                     precision: 30, scale: 10
    t.text     "237826X45X507DroppedQuiz"
    t.text     "237826X45X507DroppedScore"
    t.decimal  "237826X45X508Week2",                        precision: 30, scale: 10
    t.decimal  "237826X45X508Week3",                        precision: 30, scale: 10
    t.decimal  "237826X45X509",                             precision: 30, scale: 10
    t.decimal  "237826X45X510",                             precision: 30, scale: 10
    t.decimal  "237826X45X511HistologySkills",              precision: 30, scale: 10
    t.decimal  "237826X45X511Microbiology",                 precision: 30, scale: 10
    t.decimal  "237826X45X511OSCE",                         precision: 30, scale: 10
    t.decimal  "237826X45X511Pathlogy",                     precision: 30, scale: 10
  end

  add_index "lime_old_survey_237826_20150123091000", ["token"], name: "idx_survey_token_237826_30935", using: :btree

  create_table "lime_old_survey_286313_20150114104909", force: :cascade do |t|
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",     limit: 20,  null: false
    t.string   "286313X5X104",      limit: 255
    t.string   "286313X5X103SQ001", limit: 5
    t.string   "286313X5X103SQ002", limit: 5
    t.string   "286313X5X103SQ003", limit: 5
    t.string   "286313X5X103SQ004", limit: 5
    t.string   "286313X5X103SQ005", limit: 5
    t.string   "286313X5X103SQ006", limit: 5
    t.string   "286313X5X103SQ007", limit: 5
    t.string   "286313X5X103SQ008", limit: 5
    t.string   "286313X5X103SQ009", limit: 5
    t.string   "286313X5X103SQ010", limit: 5
    t.string   "286313X5X103SQ011", limit: 5
    t.string   "286313X5X103SQ012", limit: 5
  end

  create_table "lime_old_survey_352355_20150611103413", force: :cascade do |t|
    t.string   "token",                            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                    limit: 20,                           null: false
    t.text     "352355X65X1071StudentEmail"
    t.text     "352355X65X1071StudentName"
    t.text     "352355X65X1071CoachEmail"
    t.text     "352355X65X1071CoachName"
    t.text     "352355X66X1072CourseYear"
    t.text     "352355X66X1072CourseName"
    t.decimal  "352355X66X1073Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week5MCQ",                      precision: 30, scale: 10
    t.text     "352355X66X1074DroppedQuiz"
    t.text     "352355X66X1074DroppedScore"
    t.decimal  "352355X66X1075Anatomy",                       precision: 30, scale: 10
    t.decimal  "352355X66X1075DermatologyImages",             precision: 30, scale: 10
    t.decimal  "352355X66X1075Informatics",                   precision: 30, scale: 10
    t.decimal  "352355X66X1075Week3CSAArithritis",            precision: 30, scale: 10
    t.decimal  "352355X66X1076",                              precision: 30, scale: 10
    t.decimal  "352355X66X1077",                              precision: 30, scale: 10
    t.decimal  "352355X66X1078AnatomyFinal",                  precision: 30, scale: 10
    t.decimal  "352355X66X1078Histology",                     precision: 30, scale: 10
    t.decimal  "352355X66X1078ProblemRep",                    precision: 30, scale: 10
    t.decimal  "352355X66X1078VisualImages",                  precision: 30, scale: 10
    t.decimal  "352355X66X1079Component1",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component2",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component3",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component4",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component5",                    precision: 30, scale: 10
    t.text     "352355X66X1080ComponentFailed"
    t.text     "352355X66X1080AreasOfDeficiency"
    t.text     "352355X66X1080RetestResults"
    t.text     "352355X66X1080RetestResultPNP"
    t.text     "352355X66X1080NoOfPrevcompFails"
    t.text     "352355X66X1080NoOfFailuresToDate"
    t.text     "352355X66X1080LetterSent"
    t.text     "352355X66X1080MSPBDiscussed"
    t.text     "352355X66X1081ComponentFailed"
    t.text     "352355X66X1081AreasOfDeficiency"
    t.text     "352355X66X1081RetestResults"
    t.text     "352355X66X1081RetestResultPNP"
    t.text     "352355X66X1081NoOfPrevcompFails"
    t.text     "352355X66X1081NoOfFailuresToDate"
    t.text     "352355X66X1081LetterSent"
    t.text     "352355X66X1081MSPBDiscussed"
  end

  add_index "lime_old_survey_352355_20150611103413", ["token"], name: "idx_survey_token_352355_30284", using: :btree

  create_table "lime_old_survey_361623_20150701133029", force: :cascade do |t|
    t.string   "token",                                    limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                            limit: 20,                            null: false
    t.text     "361623X106X1623FirstName"
    t.text     "361623X106X1623LastName"
    t.text     "361623X106X1623Address1"
    t.text     "361623X106X1623Address2"
    t.text     "361623X106X1623City"
    t.text     "361623X106X1623State"
    t.text     "361623X106X1623ZipCode"
    t.text     "361623X106X1623HomePhone"
    t.text     "361623X106X1623MobilePhone"
    t.datetime "361623X106X1624"
    t.string   "361623X106X1625",                          limit: 5
    t.text     "361623X106X1625other"
    t.string   "361623X106X1626",                          limit: 5
    t.text     "361623X106X1626other"
    t.string   "361623X106X1627",                          limit: 5
    t.string   "361623X106X16281",                         limit: 5
    t.string   "361623X106X16282",                         limit: 5
    t.string   "361623X106X16283",                         limit: 5
    t.string   "361623X106X16284",                         limit: 5
    t.string   "361623X106X16285",                         limit: 5
    t.text     "361623X106X1628other"
    t.string   "361623X106X1629",                          limit: 5
    t.string   "361623X106X1714",                          limit: 1
    t.text     "361623X106X1630Child1_Age1"
    t.text     "361623X106X1630Child2_Age1"
    t.text     "361623X106X1630Child3_Age1"
    t.text     "361623X106X1630Child4_Age1"
    t.text     "361623X106X1630Child5_Age1"
    t.text     "361623X106X1631City"
    t.text     "361623X106X1631State"
    t.text     "361623X106X1631Country"
    t.text     "361623X106X1632City"
    t.text     "361623X106X1632State"
    t.text     "361623X106X1632Country"
    t.text     "361623X106X1715Hobby1"
    t.text     "361623X106X1715Hobby2"
    t.text     "361623X106X1715Hobby3"
    t.decimal  "361623X107X1633",                                      precision: 30, scale: 10
    t.text     "361623X107X1634Row1_Institution"
    t.text     "361623X107X1634Row1_DegreeAttained"
    t.text     "361623X107X1634Row1_MajorAreaStudy"
    t.text     "361623X107X1634Row1_MinorAreaStudy"
    t.text     "361623X107X1634Row1_YrGrad"
    t.text     "361623X107X1634Row1_ScienceCoursesHrs"
    t.text     "361623X107X1634Row1_ScienceCoursesGPA"
    t.text     "361623X107X1634Row1_OverallGPA"
    t.text     "361623X107X1634Row2_Institution"
    t.text     "361623X107X1634Row2_DegreeAttained"
    t.text     "361623X107X1634Row2_MajorAreaStudy"
    t.text     "361623X107X1634Row2_MinorAreaStudy"
    t.text     "361623X107X1634Row2_YrGrad"
    t.text     "361623X107X1634Row2_ScienceCoursesHrs"
    t.text     "361623X107X1634Row2_ScienceCoursesGPA"
    t.text     "361623X107X1634Row2_OverallGPA"
    t.text     "361623X107X1634Row3_Institution"
    t.text     "361623X107X1634Row3_DegreeAttained"
    t.text     "361623X107X1634Row3_MajorAreaStudy"
    t.text     "361623X107X1634Row3_MinorAreaStudy"
    t.text     "361623X107X1634Row3_YrGrad"
    t.text     "361623X107X1634Row3_ScienceCoursesHrs"
    t.text     "361623X107X1634Row3_ScienceCoursesGPA"
    t.text     "361623X107X1634Row3_OverallGPA"
    t.text     "361623X107X1634Row4_Institution"
    t.text     "361623X107X1634Row4_DegreeAttained"
    t.text     "361623X107X1634Row4_MajorAreaStudy"
    t.text     "361623X107X1634Row4_MinorAreaStudy"
    t.text     "361623X107X1634Row4_YrGrad"
    t.text     "361623X107X1634Row4_ScienceCoursesHrs"
    t.text     "361623X107X1634Row4_ScienceCoursesGPA"
    t.text     "361623X107X1634Row4_OverallGPA"
    t.string   "361623X107X1720",                          limit: 255
    t.text     "361623X107X1635Row1_YrMCAT"
    t.text     "361623X107X1635Row1_PhsySciences"
    t.text     "361623X107X1635Row1_VerbalReasoning"
    t.text     "361623X107X1635Row1_BioSciences"
    t.text     "361623X107X1635Row1_MCATTotScore"
    t.text     "361623X107X1635Row2_YrMCAT"
    t.text     "361623X107X1635Row2_PhsySciences"
    t.text     "361623X107X1635Row2_VerbalReasoning"
    t.text     "361623X107X1635Row2_BioSciences"
    t.text     "361623X107X1635Row2_MCATTotScore"
    t.text     "361623X107X1635Row3_YrMCAT"
    t.text     "361623X107X1635Row3_PhsySciences"
    t.text     "361623X107X1635Row3_VerbalReasoning"
    t.text     "361623X107X1635Row3_BioSciences"
    t.text     "361623X107X1635Row3_MCATTotScore"
    t.text     "361623X107X1636Row1_YrMCAT"
    t.text     "361623X107X1636Row1_ChemPhyBioSys"
    t.text     "361623X107X1636Row1_CriticalAnalysis"
    t.text     "361623X107X1636Row1_BioFoundOfLivingSys"
    t.text     "361623X107X1636Row1_PsychSocBioFoundOfBe"
    t.text     "361623X107X1636Row1_MCATTotScore"
    t.text     "361623X107X1636Row2_YrMCAT"
    t.text     "361623X107X1636Row2_ChemPhyBioSys"
    t.text     "361623X107X1636Row2_CriticalAnalysis"
    t.text     "361623X107X1636Row2_BioFoundOfLivingSys"
    t.text     "361623X107X1636Row2_PsychSocBioFoundOfBe"
    t.text     "361623X107X1636Row2_MCATTotScore"
    t.text     "361623X107X1636Row3_YrMCAT"
    t.text     "361623X107X1636Row3_ChemPhyBioSys"
    t.text     "361623X107X1636Row3_CriticalAnalysis"
    t.text     "361623X107X1636Row3_BioFoundOfLivingSys"
    t.text     "361623X107X1636Row3_PsychSocBioFoundOfBe"
    t.text     "361623X107X1636Row3_MCATTotScore"
    t.string   "361623X107X1637",                          limit: 5
    t.text     "361623X107X1638Row1_HealthcareSetting"
    t.text     "361623X107X1638Row1_CountryServed"
    t.text     "361623X107X1638Row1_Role"
    t.text     "361623X107X1638Row1_InclusiveYrs"
    t.text     "361623X107X1638Row2_HealthcareSetting"
    t.text     "361623X107X1638Row2_CountryServed"
    t.text     "361623X107X1638Row2_Role"
    t.text     "361623X107X1638Row2_InclusiveYrs"
    t.text     "361623X107X1638Row3_HealthcareSetting"
    t.text     "361623X107X1638Row3_CountryServed"
    t.text     "361623X107X1638Row3_Role"
    t.text     "361623X107X1638Row3_InclusiveYrs"
    t.text     "361623X107X1721Experience1"
    t.text     "361623X107X1721Experience2"
    t.text     "361623X107X1721Experience3"
    t.string   "361623X107X1639",                          limit: 5
    t.string   "361623X107X16401",                         limit: 5
    t.string   "361623X107X16402",                         limit: 5
    t.string   "361623X107X16403",                         limit: 5
    t.string   "361623X107X16404",                         limit: 5
    t.string   "361623X107X16405",                         limit: 5
    t.string   "361623X107X16406",                         limit: 5
    t.string   "361623X107X16407",                         limit: 5
    t.string   "361623X107X16408",                         limit: 5
    t.string   "361623X107X16409",                         limit: 5
    t.string   "361623X107X164010",                        limit: 5
    t.string   "361623X107X164011",                        limit: 5
    t.string   "361623X107X164012",                        limit: 5
    t.string   "361623X107X164013",                        limit: 5
    t.string   "361623X107X164014",                        limit: 5
    t.string   "361623X107X164015",                        limit: 5
    t.string   "361623X107X164016",                        limit: 5
    t.string   "361623X107X164017",                        limit: 5
    t.string   "361623X107X164018",                        limit: 5
    t.string   "361623X107X164019",                        limit: 5
    t.string   "361623X107X164020",                        limit: 5
    t.string   "361623X107X164021",                        limit: 5
    t.string   "361623X107X164022",                        limit: 5
    t.string   "361623X107X164023",                        limit: 5
    t.string   "361623X108X16411",                         limit: 5
    t.string   "361623X108X16412",                         limit: 5
    t.string   "361623X108X16413",                         limit: 5
    t.string   "361623X108X16414",                         limit: 5
    t.string   "361623X108X16415",                         limit: 5
    t.string   "361623X108X16416",                         limit: 5
    t.string   "361623X108X16417",                         limit: 5
    t.decimal  "361623X108X1642NoOfAdults",                            precision: 30, scale: 10
    t.decimal  "361623X108X1642NoOfChildrens",                         precision: 30, scale: 10
  end

  add_index "lime_old_survey_361623_20150701133029", ["token"], name: "idx_survey_token_361623_25420", using: :btree

  create_table "lime_old_survey_377817_20150506085154", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,                           null: false
    t.text     "377817X70X1200StudentYear"
    t.text     "377817X70X1200StudentEmail"
    t.text     "377817X70X1200StudentName"
    t.text     "377817X70X1200CoachEmail"
    t.text     "377817X70X1200CoachName"
    t.text     "377817X71X1201CourseYear"
    t.text     "377817X71X1201CourseName"
    t.decimal  "377817X71X1202Week1MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week2MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week4MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week5MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week6MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week7MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week8MCQ",                       precision: 30, scale: 10
    t.text     "377817X71X1203DroppedQuiz"
    t.text     "377817X71X1203DroppedScore"
    t.decimal  "377817X71X1204FOMA",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA7",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA8",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA9",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA10",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA11",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA12",                          precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockCardiac",              precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockRenal",                precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockPulmonary",            precision: 30, scale: 10
    t.decimal  "377817X71X1206",                               precision: 30, scale: 10
    t.decimal  "377817X71X1207OSCE",                           precision: 30, scale: 10
    t.decimal  "377817X71X1207Histology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Pathology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Microbiology",                   precision: 30, scale: 10
    t.decimal  "377817X71X1208Component1",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component2",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component3",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component4",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component5",                     precision: 30, scale: 10
  end

  add_index "lime_old_survey_377817_20150506085154", ["token"], name: "idx_survey_token_377817_44741", using: :btree

  create_table "lime_old_survey_377817_20150519104548", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,                           null: false
    t.text     "377817X70X1200StudentYear"
    t.text     "377817X70X1200StudentEmail"
    t.text     "377817X70X1200StudentName"
    t.text     "377817X70X1200CoachEmail"
    t.text     "377817X70X1200CoachName"
    t.text     "377817X71X1201CourseYear"
    t.text     "377817X71X1201CourseName"
    t.decimal  "377817X71X1202Week1MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week2MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week4MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week5MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week6MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week7MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week8MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week9MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week10MCQ",                      precision: 30, scale: 10
    t.text     "377817X71X1203DroppedQuiz"
    t.text     "377817X71X1203DroppedScore"
    t.decimal  "377817X71X1204FOMA",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA7",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA8",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA9",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA10",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA11",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA12",                          precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockCardiac",              precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockRenal",                precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockPulmonary",            precision: 30, scale: 10
    t.decimal  "377817X71X1206",                               precision: 30, scale: 10
    t.decimal  "377817X71X1207OSCE",                           precision: 30, scale: 10
    t.decimal  "377817X71X1207Histology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Pathology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Microbiology",                   precision: 30, scale: 10
    t.decimal  "377817X71X1208Component1",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component2",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component3",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component4",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component5",                     precision: 30, scale: 10
  end

  add_index "lime_old_survey_377817_20150519104548", ["token"], name: "idx_survey_token_377817_40125", using: :btree

  create_table "lime_old_survey_377817_20150611104144", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,                           null: false
    t.text     "377817X70X1200StudentYear"
    t.text     "377817X70X1200StudentEmail"
    t.text     "377817X70X1200StudentName"
    t.text     "377817X70X1200CoachEmail"
    t.text     "377817X70X1200CoachName"
    t.text     "377817X71X1201CourseYear"
    t.text     "377817X71X1201CourseName"
    t.decimal  "377817X71X1202Week1MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week2MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week4MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week5MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week6MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week8MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week9MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week10MCQ",                      precision: 30, scale: 10
    t.text     "377817X71X1203DroppedQuiz"
    t.text     "377817X71X1203DroppedScore"
    t.decimal  "377817X71X1204FOMA",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA7",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA8",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA9",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA10",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA11",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA12",                          precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockCardiac",              precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockRenal",                precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockPulmonary",            precision: 30, scale: 10
    t.decimal  "377817X71X1206",                               precision: 30, scale: 10
    t.decimal  "377817X71X1207OSCE",                           precision: 30, scale: 10
    t.decimal  "377817X71X1207Histology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Pathology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Microbiology",                   precision: 30, scale: 10
    t.decimal  "377817X71X1208Component1",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component2",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component3",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component4",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component5",                     precision: 30, scale: 10
  end

  add_index "lime_old_survey_377817_20150611104144", ["token"], name: "idx_survey_token_377817_16855", using: :btree

  create_table "lime_old_survey_624522_20150611075242", force: :cascade do |t|
    t.string   "token",                            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                    limit: 20,                           null: false
    t.text     "624522X63X1008StudentEmail"
    t.text     "624522X63X1008StudentName"
    t.text     "624522X63X1008CoachEmail"
    t.text     "624522X63X1008CoachName"
    t.text     "624522X62X1009CourseYear"
    t.text     "624522X62X1009CourseName"
    t.decimal  "624522X62X1002Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week5MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week6MCQ",                      precision: 30, scale: 10
    t.decimal  "624522X62X1002Week7MCQ",                      precision: 30, scale: 10
    t.text     "624522X62X1007DroppedQuiz"
    t.text     "624522X62X1007DroppedScore"
    t.decimal  "624522X62X1003Week2",                         precision: 30, scale: 10
    t.decimal  "624522X62X1003Week4",                         precision: 30, scale: 10
    t.decimal  "624522X62X1003Week6",                         precision: 30, scale: 10
    t.decimal  "624522X62X1004",                              precision: 30, scale: 10
    t.decimal  "624522X62X1005",                              precision: 30, scale: 10
    t.decimal  "624522X62X1006OSCE1",                         precision: 30, scale: 10
    t.decimal  "624522X62X1006OSCE2",                         precision: 30, scale: 10
    t.decimal  "624522X62X1006HistologySkills",               precision: 30, scale: 10
    t.decimal  "624522X62X1006GeneticsPedigree",              precision: 30, scale: 10
    t.decimal  "624522X62X1010Component1",                    precision: 30, scale: 10
    t.decimal  "624522X62X1010Component2",                    precision: 30, scale: 10
    t.decimal  "624522X62X1010Component3",                    precision: 30, scale: 10
    t.decimal  "624522X62X1010Component4",                    precision: 30, scale: 10
    t.decimal  "624522X62X1010Component5",                    precision: 30, scale: 10
    t.text     "624522X62X1011ComponentFailed"
    t.text     "624522X62X1011AreasOfDeficiency"
    t.text     "624522X62X1011RetestResults"
    t.text     "624522X62X1011RetestResultPNP"
    t.text     "624522X62X1011NoOfPrevcompFails"
    t.text     "624522X62X1011NoOfFailuresToDate"
    t.text     "624522X62X1011LetterSent"
    t.text     "624522X62X1011MSPBDiscussed"
    t.text     "624522X62X1012ComponentFailed"
    t.text     "624522X62X1012AreasOfDeficiency"
    t.text     "624522X62X1012RetestResults"
    t.text     "624522X62X1012RetestResultPNP"
    t.text     "624522X62X1012NoOfPrevcompFails"
    t.text     "624522X62X1012NoOfFailuresToDate"
    t.text     "624522X62X1012LetterSent"
    t.text     "624522X62X1012MSPBDiscussed"
  end

  add_index "lime_old_survey_624522_20150611075242", ["token"], name: "idx_survey_token_624522_43158", using: :btree

  create_table "lime_old_survey_763739_20150112092023", force: :cascade do |t|
    t.string   "token",                            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                    limit: 20,  null: false
    t.string   "763739X4X101",                     limit: 255
    t.string   "763739X25X77RateYourHealth4Weeks", limit: 5
    t.string   "763739X25X78ProblemsWalking",      limit: 5
    t.string   "763739X25X78DifficultDailyWork",   limit: 5
    t.string   "763739X25X78EmotionsProb",         limit: 5
    t.string   "763739X25X78PersonalProbUsualWor", limit: 5
    t.string   "763739X25X79BodilyPain",           limit: 5
    t.string   "763739X25X80Past4WeekEnergyLevel", limit: 5
    t.string   "763739X25X81BotheredEmotionalPro", limit: 5
    t.string   "763739X26X82BennUpset",            limit: 5
    t.string   "763739X26X82UnableControl",        limit: 5
    t.string   "763739X26X82FeltNervous",          limit: 5
    t.string   "763739X26X82FeltConfident",        limit: 5
    t.string   "763739X26X82FeltGoingYourWay",     limit: 5
    t.string   "763739X26X82CouldNotCope",         limit: 5
    t.string   "763739X26X82AbleToControl",        limit: 5
    t.string   "763739X26X82OnTopOfThings",        limit: 5
    t.string   "763739X26X82BeenAngered",          limit: 5
    t.string   "763739X26X82PilingUpHigh",         limit: 5
  end

  add_index "lime_old_survey_763739_20150112092023", ["token"], name: "idx_survey_token_763739_8867", using: :btree

  create_table "lime_old_survey_777632_20150817115218", force: :cascade do |t|
    t.string   "token",                               limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                       limit: 20,  null: false
    t.string   "777632X105X1599",                     limit: 255
    t.text     "777632X102X1598StudentEmail"
    t.text     "777632X102X1598StudentName"
    t.text     "777632X102X1598StudentID"
    t.text     "777632X102X1598CoachEmail"
    t.text     "777632X102X1598CoachName"
    t.string   "777632X103X1592RateYourHealth4Weeks", limit: 5
    t.string   "777632X103X1593ProblemsWalking",      limit: 5
    t.string   "777632X103X1593DifficultDailyWork",   limit: 5
    t.string   "777632X103X1593EmotionsProb",         limit: 5
    t.string   "777632X103X1593PersonalProbUsualWor", limit: 5
    t.string   "777632X103X1594BodilyPain",           limit: 5
    t.string   "777632X103X1595Past4WeekEnergyLevel", limit: 5
    t.string   "777632X103X1596BotheredEmotionalPro", limit: 5
    t.string   "777632X104X1597BennUpset",            limit: 5
    t.string   "777632X104X1597UnableControl",        limit: 5
    t.string   "777632X104X1597FeltNervous",          limit: 5
    t.string   "777632X104X1597FeltConfident",        limit: 5
    t.string   "777632X104X1597FeltGoingYourWay",     limit: 5
    t.string   "777632X104X1597CouldNotCope",         limit: 5
    t.string   "777632X104X1597AbleToControl",        limit: 5
    t.string   "777632X104X1597OnTopOfThings",        limit: 5
    t.string   "777632X104X1597BeenAngered",          limit: 5
    t.string   "777632X104X1597PilingUpHigh",         limit: 5
  end

  add_index "lime_old_survey_777632_20150817115218", ["token"], name: "idx_survey_token_777632_28352", using: :btree

  create_table "lime_old_survey_777786_20150819110452", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1407"
    t.string   "777786X88X1408",                     limit: 255
    t.text     "777786X88X1409"
    t.text     "777786X88X1410"
    t.string   "777786X88X1917",                     limit: 5
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150819110452", ["token"], name: "idx_survey_token_777786_27711", using: :btree

  create_table "lime_old_survey_777786_20150820075623", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1407"
    t.string   "777786X88X1408",                     limit: 255
    t.text     "777786X88X1409"
    t.text     "777786X88X1410"
    t.string   "777786X88X1917",                     limit: 5
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150820075623", ["token"], name: "idx_survey_token_777786_20058", using: :btree

  create_table "lime_old_survey_777786_20150820075917", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1407"
    t.string   "777786X88X1408",                     limit: 255
    t.text     "777786X88X1409"
    t.text     "777786X88X1410"
    t.string   "777786X88X1917",                     limit: 5
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150820075917", ["token"], name: "idx_survey_token_777786_30395", using: :btree

  create_table "lime_old_survey_777786_20150820080450", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1407"
    t.string   "777786X88X1408",                     limit: 255
    t.text     "777786X88X1409"
    t.text     "777786X88X1410"
    t.string   "777786X88X1917",                     limit: 5
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150820080450", ["token"], name: "idx_survey_token_777786_21819", using: :btree

  create_table "lime_old_survey_777786_20150827084208", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1407"
    t.string   "777786X88X1408",                     limit: 255
    t.text     "777786X88X1409"
    t.text     "777786X88X1410"
    t.string   "777786X88X1917",                     limit: 5
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150827084208", ["token"], name: "idx_survey_token_777786_30452", using: :btree

  create_table "lime_old_survey_777786_20150827090008", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1410"
    t.text     "777786X88X1409"
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
    t.string   "777786X122X1961",                    limit: 5
    t.string   "777786X122X1962",                    limit: 255
  end

  add_index "lime_old_survey_777786_20150827090008", ["token"], name: "idx_survey_token_777786_16513", using: :btree

  create_table "lime_old_survey_777786_20150828072536", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.text     "777786X88X1400"
    t.text     "777786X88X1410"
    t.text     "777786X88X1409"
    t.string   "777786X122X1961",                    limit: 5
    t.string   "777786X122X1962",                    limit: 255
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
  end

  add_index "lime_old_survey_777786_20150828072536", ["token"], name: "idx_survey_token_777786_1108", using: :btree

  create_table "lime_old_survey_834556_20150828083836", force: :cascade do |t|
    t.string   "token",                limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",        limit: 20,  null: false
    t.datetime "startdate",                        null: false
    t.datetime "datestamp",                        null: false
    t.string   "834556X116X1872",      limit: 255
    t.text     "834556X114X1854"
    t.text     "834556X114X1855"
    t.text     "834556X114X1856"
    t.string   "834556X114X1857",      limit: 1
    t.text     "834556X114X1858"
    t.text     "834556X114X1859"
    t.string   "834556X115X1860SQ001", limit: 5
    t.string   "834556X115X1860SQ002", limit: 5
    t.string   "834556X115X1860SQ003", limit: 5
    t.string   "834556X115X1860SQ004", limit: 5
    t.string   "834556X115X1860SQ005", limit: 5
    t.string   "834556X115X1860SQ006", limit: 5
    t.string   "834556X115X1860SQ007", limit: 5
    t.string   "834556X115X1860SQ008", limit: 5
    t.string   "834556X115X1860SQ009", limit: 5
    t.string   "834556X115X1860SQ010", limit: 5
    t.string   "834556X115X1860SQ011", limit: 5
  end

  add_index "lime_old_survey_834556_20150828083836", ["token"], name: "idx_survey_token_834556_30494", using: :btree

  create_table "lime_old_survey_834556_20150831064817", force: :cascade do |t|
    t.string   "token",                limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",        limit: 20,  null: false
    t.datetime "startdate",                        null: false
    t.datetime "datestamp",                        null: false
    t.string   "834556X116X1872",      limit: 255
    t.text     "834556X114X1854"
    t.text     "834556X114X1855"
    t.text     "834556X114X1856"
    t.string   "834556X114X1857",      limit: 1
    t.text     "834556X114X1858"
    t.text     "834556X114X1859"
    t.string   "834556X115X1860SQ001", limit: 5
    t.string   "834556X115X1860SQ002", limit: 5
    t.string   "834556X115X1860SQ003", limit: 5
    t.string   "834556X115X1860SQ004", limit: 5
    t.string   "834556X115X1860SQ005", limit: 5
    t.string   "834556X115X1860SQ006", limit: 5
    t.string   "834556X115X1860SQ007", limit: 5
    t.string   "834556X115X1860SQ008", limit: 5
    t.string   "834556X115X1860SQ009", limit: 5
    t.string   "834556X115X1860SQ010", limit: 5
    t.string   "834556X115X1860SQ011", limit: 5
  end

  add_index "lime_old_survey_834556_20150831064817", ["token"], name: "idx_survey_token_834556_42370", using: :btree

  create_table "lime_old_survey_834556_20150831072725", force: :cascade do |t|
    t.string   "token",                limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",        limit: 20,  null: false
    t.datetime "startdate",                        null: false
    t.datetime "datestamp",                        null: false
    t.string   "834556X128X2020",      limit: 255
    t.text     "834556X126X2013"
    t.text     "834556X126X2014"
    t.text     "834556X126X2015"
    t.string   "834556X126X2016",      limit: 1
    t.text     "834556X126X2017"
    t.text     "834556X126X2018"
    t.string   "834556X127X2019SQ001", limit: 5
    t.string   "834556X127X2019SQ002", limit: 5
    t.string   "834556X127X2019SQ003", limit: 5
    t.string   "834556X127X2019SQ004", limit: 5
    t.string   "834556X127X2019SQ005", limit: 5
    t.string   "834556X127X2019SQ006", limit: 5
    t.string   "834556X127X2019SQ007", limit: 5
    t.string   "834556X127X2019SQ008", limit: 5
    t.string   "834556X127X2019SQ009", limit: 5
    t.string   "834556X127X2019SQ010", limit: 5
    t.string   "834556X127X2019SQ011", limit: 5
  end

  add_index "lime_old_survey_834556_20150831072725", ["token"], name: "idx_survey_token_834556_10773", using: :btree

  create_table "lime_old_survey_834556_timings_20150828083836", force: :cascade do |t|
    t.float "interviewtime"
    t.float "834556X116time"
    t.float "834556X116X1872time"
    t.float "834556X114time"
    t.float "834556X114X1854time"
    t.float "834556X114X1855time"
    t.float "834556X114X1856time"
    t.float "834556X114X1857time"
    t.float "834556X114X1858time"
    t.float "834556X114X1859time"
    t.float "834556X115time"
    t.float "834556X115X1860time"
  end

  create_table "lime_old_survey_834556_timings_20150831064817", force: :cascade do |t|
    t.float "interviewtime"
    t.float "834556X116time"
    t.float "834556X116X1872time"
    t.float "834556X114time"
    t.float "834556X114X1854time"
    t.float "834556X114X1855time"
    t.float "834556X114X1856time"
    t.float "834556X114X1857time"
    t.float "834556X114X1858time"
    t.float "834556X114X1859time"
    t.float "834556X115time"
    t.float "834556X115X1860time"
  end

  create_table "lime_old_survey_834556_timings_20150831072725", force: :cascade do |t|
    t.float "interviewtime"
    t.float "834556X128time"
    t.float "834556X128X2020time"
    t.float "834556X126time"
    t.float "834556X126X2013time"
    t.float "834556X126X2014time"
    t.float "834556X126X2015time"
    t.float "834556X126X2016time"
    t.float "834556X126X2017time"
    t.float "834556X126X2018time"
    t.float "834556X127time"
    t.float "834556X127X2019time"
  end

  create_table "lime_old_survey_838243_20150803141600", force: :cascade do |t|
    t.string   "token",                      limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",              limit: 20,                           null: false
    t.text     "838243X81X1309StudentYear"
    t.text     "838243X81X1309StudentEmail"
    t.text     "838243X81X1309StudentName"
    t.text     "838243X81X1309CoachEmail"
    t.text     "838243X81X1309CoachName"
    t.text     "838243X80X1310CourseYear"
    t.text     "838243X80X1310CourseName"
    t.decimal  "838243X80X1303Week1MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week2MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week3MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week4MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week5MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week6MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week7MCQ",                precision: 30, scale: 10
    t.text     "838243X80X1308DroppedQuiz"
    t.text     "838243X80X1308DroppedScore"
    t.decimal  "838243X80X1304CSA1",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA2",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA3",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA4",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA5",                    precision: 30, scale: 10
    t.decimal  "838243X80X1305",                        precision: 30, scale: 10
    t.decimal  "838243X80X1306",                        precision: 30, scale: 10
    t.decimal  "838243X80X1307OSCE",                    precision: 30, scale: 10
    t.decimal  "838243X80X1307Histology",               precision: 30, scale: 10
    t.decimal  "838243X80X1307Pathology",               precision: 30, scale: 10
    t.decimal  "838243X80X1307Microbiology",            precision: 30, scale: 10
    t.decimal  "838243X80X1311Component1",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component2",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component3",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component4",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component5",              precision: 30, scale: 10
    t.text     "838243X80X1312"
    t.integer  "838243X80X1312_filecount"
  end

  add_index "lime_old_survey_838243_20150803141600", ["token"], name: "idx_survey_token_838243_6512", using: :btree

  create_table "lime_old_survey_887795_20150611102826", force: :cascade do |t|
    t.string   "token",                           limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                   limit: 20,                           null: false
    t.text     "887795X58X888StudentEmail"
    t.text     "887795X58X888StudentName"
    t.text     "887795X58X888CoachEmail"
    t.text     "887795X58X888CoachName"
    t.text     "887795X59X895CourseYear"
    t.text     "887795X59X895CourseName"
    t.decimal  "887795X59X889Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "887795X59X889Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "887795X59X889Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "887795X59X889Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "887795X59X889Week5MCQ",                      precision: 30, scale: 10
    t.text     "887795X59X890DroppedQuiz"
    t.text     "887795X59X890DroppedScore"
    t.decimal  "887795X59X891Week2",                         precision: 30, scale: 10
    t.decimal  "887795X59X891Week3",                         precision: 30, scale: 10
    t.decimal  "887795X59X892",                              precision: 30, scale: 10
    t.decimal  "887795X59X893",                              precision: 30, scale: 10
    t.decimal  "887795X59X894HistologySkills",               precision: 30, scale: 10
    t.decimal  "887795X59X894Microbiology",                  precision: 30, scale: 10
    t.decimal  "887795X59X894OSCE",                          precision: 30, scale: 10
    t.decimal  "887795X59X894Pathlogy",                      precision: 30, scale: 10
    t.decimal  "887795X59X896Component1",                    precision: 30, scale: 10
    t.decimal  "887795X59X896Component2",                    precision: 30, scale: 10
    t.decimal  "887795X59X896Component3",                    precision: 30, scale: 10
    t.decimal  "887795X59X896Component4",                    precision: 30, scale: 10
    t.decimal  "887795X59X896Component5",                    precision: 30, scale: 10
    t.text     "887795X59X897ComponentFailed"
    t.text     "887795X59X897AreasOfDeficiency"
    t.text     "887795X59X897RetestResults"
    t.text     "887795X59X897RetestResultPNP"
    t.text     "887795X59X897NoOfPrevcompFails"
    t.text     "887795X59X897NoOfFailuresToDate"
    t.text     "887795X59X897LetterSent"
    t.text     "887795X59X897MSPBDiscussed"
    t.text     "887795X59X898ComponentFailed"
    t.text     "887795X59X898AreasOfDeficiency"
    t.text     "887795X59X898RetestResults"
    t.text     "887795X59X898RetestResultPNP"
    t.text     "887795X59X898NoOfPrevcompFails"
    t.text     "887795X59X898NoOfFailuresToDate"
    t.text     "887795X59X898LetterSent"
    t.text     "887795X59X898MSPBDiscussed"
  end

  add_index "lime_old_survey_887795_20150611102826", ["token"], name: "idx_survey_token_887795_44277", using: :btree

  create_table "lime_old_tokens_777632_20150817105306", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
  end

  add_index "lime_old_tokens_777632_20150817105306", ["token"], name: "idx_token_token_777632_7163", using: :btree

  create_table "lime_old_tokens_777632_20150817120706", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
  end

  add_index "lime_old_tokens_777632_20150817120706", ["token"], name: "idx_token_token_777632_43491", using: :btree

  create_table "lime_old_tokens_777632_20150817120812", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
  end

  add_index "lime_old_tokens_777632_20150817120812", ["token"], name: "idx_token_token_777632_40221", using: :btree

  create_table "lime_old_tokens_777786_20150819104344", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
    t.string   "attribute_4",    limit: 255
    t.string   "attribute_5",    limit: 255
  end

  add_index "lime_old_tokens_777786_20150819104344", ["token"], name: "idx_token_token_777786_49983", using: :btree

  create_table "lime_old_tokens_777786_20150819110452", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
    t.string   "attribute_4",    limit: 255
    t.string   "attribute_5",    limit: 255
  end

  add_index "lime_old_tokens_777786_20150819110452", ["token"], name: "idx_token_token_777786_40937", using: :btree

  create_table "lime_old_tokens_777786_20150820075623", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
    t.string   "attribute_4",    limit: 255
    t.string   "attribute_5",    limit: 255
  end

  add_index "lime_old_tokens_777786_20150820075623", ["token"], name: "idx_token_token_777786_26333", using: :btree

  create_table "lime_old_tokens_777786_20150827084319", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
    t.string   "attribute_4",    limit: 255
    t.string   "attribute_5",    limit: 255
  end

  add_index "lime_old_tokens_777786_20150827084319", ["token"], name: "idx_token_token_777786_16706", using: :btree

  create_table "lime_old_tokens_777786_20150827084334", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
    t.string   "attribute_4",    limit: 255
    t.string   "attribute_5",    limit: 255
  end

  add_index "lime_old_tokens_777786_20150827084334", ["token"], name: "idx_token_token_777786_34631", using: :btree

  create_table "lime_old_tokens_834556_20150831064817", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 40
    t.string   "lastname",       limit: 40
    t.text     "email"
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.string   "attribute_1",    limit: 255
    t.string   "attribute_2",    limit: 255
    t.string   "attribute_3",    limit: 255
  end

  add_index "lime_old_tokens_834556_20150831064817", ["token"], name: "idx_token_token_834556_35691", using: :btree

  create_table "lime_participant_attribute", id: false, force: :cascade do |t|
    t.string  "participant_id", limit: 50, null: false
    t.integer "attribute_id",              null: false
    t.text    "value",                     null: false
  end

  create_table "lime_participant_attribute_names", primary_key: "attribute_id", force: :cascade do |t|
    t.string "attribute_type", limit: 4,  null: false
    t.string "defaultname",    limit: 50, null: false
    t.string "visible",        limit: 5,  null: false
  end

  create_table "lime_participant_attribute_names_lang", id: false, force: :cascade do |t|
    t.integer "attribute_id",               null: false
    t.string  "attribute_name", limit: 30,  null: false
    t.string  "lang",           limit: 255, null: false
  end

  create_table "lime_participant_attribute_values", primary_key: "value_id", force: :cascade do |t|
    t.integer "attribute_id", null: false
    t.text    "value",        null: false
  end

  create_table "lime_participant_shares", id: false, force: :cascade do |t|
    t.string   "participant_id", limit: 50, null: false
    t.integer  "share_uid",                 null: false
    t.datetime "date_added",                null: false
    t.string   "can_edit",       limit: 5,  null: false
  end

  create_table "lime_participants", primary_key: "participant_id", force: :cascade do |t|
    t.string   "firstname",   limit: 150, null: false
    t.string   "lastname",    limit: 150, null: false
    t.string   "email",       limit: 254, null: false
    t.string   "language",    limit: 40
    t.string   "blacklisted", limit: 1,   null: false
    t.integer  "owner_uid",               null: false
    t.integer  "created_by",              null: false
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "lime_permissions", force: :cascade do |t|
    t.string  "entity",     limit: 50,              null: false
    t.integer "entity_id",                          null: false
    t.integer "uid",                                null: false
    t.string  "permission", limit: 100,             null: false
    t.integer "create_p",               default: 0, null: false
    t.integer "read_p",                 default: 0, null: false
    t.integer "update_p",               default: 0, null: false
    t.integer "delete_p",               default: 0, null: false
    t.integer "import_p",               default: 0, null: false
    t.integer "export_p",               default: 0, null: false
  end

  add_index "lime_permissions", ["entity_id", "entity", "uid", "permission"], name: "permissions_idx2", unique: true, using: :btree

  create_table "lime_plugin_settings", force: :cascade do |t|
    t.integer "plugin_id",            null: false
    t.string  "model",     limit: 50
    t.integer "model_id"
    t.string  "key",       limit: 50, null: false
    t.text    "value"
  end

  create_table "lime_plugins", force: :cascade do |t|
    t.string  "name",   limit: 50,             null: false
    t.integer "active",            default: 0, null: false
  end

  create_table "lime_question_attributes", primary_key: "qaid", force: :cascade do |t|
    t.integer "qid",                  default: 0, null: false
    t.string  "attribute", limit: 50
    t.text    "value"
    t.string  "language",  limit: 20
  end

  add_index "lime_question_attributes", ["attribute"], name: "question_attributes_idx3", using: :btree
  add_index "lime_question_attributes", ["qid"], name: "question_attributes_idx2", using: :btree

  create_table "lime_questions", id: false, force: :cascade do |t|
    t.integer "qid",                       default: "nextval('lime_questions_qid_seq'::regclass)", null: false
    t.integer "parent_qid",                default: 0,                                             null: false
    t.integer "sid",                       default: 0,                                             null: false
    t.integer "gid",                       default: 0,                                             null: false
    t.string  "type",           limit: 1,  default: "T",                                           null: false
    t.string  "title",          limit: 20, default: "",                                            null: false
    t.text    "question",                                                                          null: false
    t.text    "preg"
    t.text    "help"
    t.string  "other",          limit: 1,  default: "N",                                           null: false
    t.string  "mandatory",      limit: 1
    t.integer "question_order",                                                                    null: false
    t.string  "language",       limit: 20, default: "en",                                          null: false
    t.integer "scale_id",                  default: 0,                                             null: false
    t.integer "same_default",              default: 0,                                             null: false
    t.text    "relevance"
  end

  add_index "lime_questions", ["gid"], name: "questions_idx3", using: :btree
  add_index "lime_questions", ["parent_qid"], name: "parent_qid_idx", using: :btree
  add_index "lime_questions", ["sid"], name: "questions_idx2", using: :btree
  add_index "lime_questions", ["type"], name: "questions_idx4", using: :btree

  create_table "lime_quota", force: :cascade do |t|
    t.integer "sid"
    t.string  "name",         limit: 255
    t.integer "qlimit"
    t.integer "action"
    t.integer "active",                   default: 1, null: false
    t.integer "autoload_url",             default: 0, null: false
  end

  add_index "lime_quota", ["sid"], name: "quota_idx2", using: :btree

  create_table "lime_quota_languagesettings", primary_key: "quotals_id", force: :cascade do |t|
    t.integer "quotals_quota_id",               default: 0,    null: false
    t.string  "quotals_language",   limit: 45,  default: "en", null: false
    t.string  "quotals_name",       limit: 255
    t.text    "quotals_message",                               null: false
    t.string  "quotals_url",        limit: 255
    t.string  "quotals_urldescrip", limit: 255
  end

  create_table "lime_quota_members", force: :cascade do |t|
    t.integer "sid"
    t.integer "qid"
    t.integer "quota_id"
    t.string  "code",     limit: 11
  end

  add_index "lime_quota_members", ["sid", "qid", "quota_id", "code"], name: "lime_quota_members_ixcode_idx", using: :btree

  create_table "lime_saved_control", primary_key: "scid", force: :cascade do |t|
    t.integer  "sid",                        default: 0,  null: false
    t.integer  "srid",                       default: 0,  null: false
    t.text     "identifier",                              null: false
    t.text     "access_code",                             null: false
    t.string   "email",          limit: 254
    t.text     "ip",                                      null: false
    t.text     "saved_thisstep",                          null: false
    t.string   "status",         limit: 1,   default: "", null: false
    t.datetime "saved_date",                              null: false
    t.text     "refurl"
  end

  add_index "lime_saved_control", ["sid"], name: "saved_control_idx2", using: :btree

  create_table "lime_sessions", force: :cascade do |t|
    t.integer "expire"
    t.binary  "data"
  end

  create_table "lime_settings_global", primary_key: "stg_name", force: :cascade do |t|
    t.string "stg_value", limit: 255, default: "", null: false
  end

  create_table "lime_survey_115373", force: :cascade do |t|
    t.string   "token",                       limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",               limit: 20,                           null: false
    t.text     "115373X118X1879StudentYear"
    t.text     "115373X118X1879StudentEmail"
    t.text     "115373X118X1879StudentName"
    t.text     "115373X118X1879CoachEmail"
    t.text     "115373X118X1879CoachName"
    t.text     "115373X117X1880CourseYear"
    t.text     "115373X117X1880CourseName"
    t.decimal  "115373X117X1873Week1MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week2MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week3MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week4MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week5MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week6MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week7MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week8MCQ",                precision: 30, scale: 10
    t.decimal  "115373X117X1873Week9MCQ",                precision: 30, scale: 10
    t.text     "115373X117X1878DroppedQuiz"
    t.text     "115373X117X1878DroppedScore"
    t.decimal  "115373X117X1874CSA1",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA2",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA3",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA4",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA5",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA6",                    precision: 30, scale: 10
    t.decimal  "115373X117X1874CSA7",                    precision: 30, scale: 10
    t.decimal  "115373X117X1875",                        precision: 30, scale: 10
    t.decimal  "115373X117X1876",                        precision: 30, scale: 10
    t.decimal  "115373X117X1877Neuro",                   precision: 30, scale: 10
    t.decimal  "115373X117X1877Histology",               precision: 30, scale: 10
    t.decimal  "115373X117X1877Anatomy",                 precision: 30, scale: 10
    t.decimal  "115373X117X1877GrossAnatomy",            precision: 30, scale: 10
    t.decimal  "115373X117X1881Component1",              precision: 30, scale: 10
    t.decimal  "115373X117X1881Component2",              precision: 30, scale: 10
    t.decimal  "115373X117X1881Component3",              precision: 30, scale: 10
    t.decimal  "115373X117X1881Component4",              precision: 30, scale: 10
    t.decimal  "115373X117X1881Component5",              precision: 30, scale: 10
    t.text     "115373X117X1882"
    t.integer  "115373X117X1882_filecount"
  end

  add_index "lime_survey_115373", ["token"], name: "idx_survey_token_115373_45301", using: :btree

  create_table "lime_survey_217615", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.datetime "startdate",                                      null: false
    t.datetime "datestamp",                                      null: false
    t.string   "217615X96X1515",                     limit: 255
    t.string   "217615X96X1501SQ001",                limit: 5
    t.string   "217615X96X1502",                     limit: 5
    t.string   "217615X96X1503",                     limit: 1
    t.string   "217615X96X1504",                     limit: 5
    t.text     "217615X96X1504other"
    t.string   "217615X96X1505",                     limit: 1
    t.string   "217615X96X1506",                     limit: 5
    t.text     "217615X96X1506other"
    t.string   "217615X96X1507",                     limit: 1
    t.string   "217615X96X1508",                     limit: 5
    t.text     "217615X96X1508other"
    t.string   "217615X96X15091",                    limit: 5
    t.string   "217615X96X15092",                    limit: 5
    t.string   "217615X96X15093",                    limit: 5
    t.string   "217615X96X15094",                    limit: 5
    t.string   "217615X96X15095",                    limit: 5
    t.string   "217615X96X15096",                    limit: 5
    t.string   "217615X96X15097",                    limit: 5
    t.string   "217615X96X15098",                    limit: 5
    t.text     "217615X96X1509other"
    t.string   "217615X96X1510HowHelpful",           limit: 5
    t.string   "217615X96X1511VidUnderstanding",     limit: 5
    t.string   "217615X96X1511ClearContent",         limit: 5
    t.string   "217615X96X1511ReleventContent",      limit: 5
    t.string   "217615X96X1511AccurateContent",      limit: 5
    t.string   "217615X96X1511VidRightLen",          limit: 5
    t.string   "217615X96X1511DidnotFindVidHelpful", limit: 5
    t.string   "217615X96X1512AlreadyUnderstood",    limit: 5
    t.string   "217615X96X1512NotClearContent",      limit: 5
    t.string   "217615X96X1512NotReleventContent",   limit: 5
    t.string   "217615X96X1512NotCorrectContent",    limit: 5
    t.string   "217615X96X1512VidTooLong",           limit: 5
    t.string   "217615X96X1512AllVidHelpful",        limit: 5
    t.text     "217615X96X1513"
    t.text     "217615X97X1514StudentYear"
    t.text     "217615X97X1514StudentEmail"
    t.text     "217615X97X1514StudentName"
    t.text     "217615X97X1514CoachEmail"
    t.text     "217615X97X1514CoachName"
  end

  add_index "lime_survey_217615", ["token"], name: "idx_survey_token_217615_8121", using: :btree

  create_table "lime_survey_217615_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "217615X96time"
    t.float "217615X96X1515time"
    t.float "217615X96X1501time"
    t.float "217615X96X1502time"
    t.float "217615X96X1503time"
    t.float "217615X96X1504time"
    t.float "217615X96X1505time"
    t.float "217615X96X1506time"
    t.float "217615X96X1507time"
    t.float "217615X96X1508time"
    t.float "217615X96X1509time"
    t.float "217615X96X1510time"
    t.float "217615X96X1511time"
    t.float "217615X96X1512time"
    t.float "217615X96X1513time"
    t.float "217615X97time"
    t.float "217615X97X1514time"
  end

  create_table "lime_survey_224436", force: :cascade do |t|
    t.string   "token",          limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",  limit: 20,                            null: false
    t.string   "224436X64X1056", limit: 255
    t.string   "224436X64X1067", limit: 255
    t.string   "224436X64X1068", limit: 255
    t.string   "224436X64X1069", limit: 255
    t.string   "224436X64X1070", limit: 255
    t.string   "224436X64X1057", limit: 5
    t.string   "224436X64X1058", limit: 5
    t.string   "224436X64X1059", limit: 255
    t.decimal  "224436X64X1060",             precision: 30, scale: 10
    t.string   "224436X64X1061", limit: 5
    t.decimal  "224436X64X1062",             precision: 30, scale: 10
    t.decimal  "224436X64X1063",             precision: 30, scale: 10
  end

  add_index "lime_survey_224436", ["token"], name: "idx_survey_token_224436_4515", using: :btree

  create_table "lime_survey_226417", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,  null: false
    t.string   "226417X93X1451InstructorKnowledge", limit: 5
    t.string   "226417X93X1451InstructorWellPrep",  limit: 5
    t.string   "226417X93X1451InstructorRate",      limit: 5
    t.text     "226417X93X1452"
    t.text     "226417X93X1453"
    t.text     "226417X93X1454"
    t.string   "226417X93X1455",                    limit: 255
    t.string   "226417X93X1456",                    limit: 255
    t.string   "226417X93X1457",                    limit: 255
    t.string   "226417X93X1458ClickerQ",            limit: 5
    t.string   "226417X93X1458Brief",               limit: 5
    t.string   "226417X93X1458Pair",                limit: 5
  end

  add_index "lime_survey_226417", ["token"], name: "idx_survey_token_226417_26428", using: :btree

  create_table "lime_survey_231881", force: :cascade do |t|
    t.string   "token",                      limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",              limit: 20,  null: false
    t.datetime "startdate",                              null: false
    t.datetime "datestamp",                              null: false
    t.string   "231881X94X1477",             limit: 255
    t.string   "231881X94X1465SQ001",        limit: 5
    t.string   "231881X94X1466SQ001",        limit: 5
    t.string   "231881X94X1467",             limit: 5
    t.text     "231881X94X1467other"
    t.string   "231881X94X1468",             limit: 1
    t.string   "231881X94X1469",             limit: 5
    t.text     "231881X94X1469other"
    t.string   "231881X94X1470SQ001",        limit: 5
    t.string   "231881X94X1470SQ002",        limit: 5
    t.string   "231881X94X1470SQ003",        limit: 5
    t.string   "231881X94X1470SQ004",        limit: 5
    t.string   "231881X94X1470SQ005",        limit: 5
    t.string   "231881X94X1470SQ006",        limit: 5
    t.string   "231881X94X1470SQ007",        limit: 5
    t.string   "231881X94X1470SQ008",        limit: 5
    t.string   "231881X94X1470SQ009",        limit: 5
    t.string   "231881X94X1471SQ001",        limit: 5
    t.string   "231881X94X1472SQ001",        limit: 5
    t.string   "231881X94X1472SQ002",        limit: 5
    t.string   "231881X94X1472SQ003",        limit: 5
    t.string   "231881X94X1472SQ004",        limit: 5
    t.string   "231881X94X1472SQ005",        limit: 5
    t.string   "231881X94X1472SQ006",        limit: 5
    t.string   "231881X94X1473",             limit: 5
    t.string   "231881X94X1474",             limit: 5
    t.text     "231881X94X1474other"
    t.text     "231881X94X1475"
    t.text     "231881X95X1476StudentYear"
    t.text     "231881X95X1476StudentEmail"
    t.text     "231881X95X1476StudentName"
    t.text     "231881X95X1476CoachEmail"
    t.text     "231881X95X1476CoachName"
  end

  add_index "lime_survey_231881", ["token"], name: "idx_survey_token_231881_2029", using: :btree

  create_table "lime_survey_231881_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "231881X94time"
    t.float "231881X94X1477time"
    t.float "231881X94X1465time"
    t.float "231881X94X1466time"
    t.float "231881X94X1467time"
    t.float "231881X94X1468time"
    t.float "231881X94X1469time"
    t.float "231881X94X1470time"
    t.float "231881X94X1471time"
    t.float "231881X94X1472time"
    t.float "231881X94X1473time"
    t.float "231881X94X1474time"
    t.float "231881X94X1475time"
    t.float "231881X95time"
    t.float "231881X95X1476time"
  end

  create_table "lime_survey_237826", force: :cascade do |t|
    t.string   "token",                           limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                   limit: 20,                           null: false
    t.text     "237826X54X736StudentEmail"
    t.text     "237826X54X736StudentName"
    t.text     "237826X54X736CoachEmail"
    t.text     "237826X54X736CoachName"
    t.text     "237826X53X743CourseYear"
    t.text     "237826X53X743CourseName"
    t.decimal  "237826X53X730Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week5MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week6MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X53X730Week7MCQ",                      precision: 30, scale: 10
    t.text     "237826X53X735DroppedQuiz"
    t.text     "237826X53X735DroppedScore"
    t.decimal  "237826X53X731Week2",                         precision: 30, scale: 10
    t.decimal  "237826X53X731Week4",                         precision: 30, scale: 10
    t.decimal  "237826X53X731Week6",                         precision: 30, scale: 10
    t.decimal  "237826X53X732",                              precision: 30, scale: 10
    t.decimal  "237826X53X733",                              precision: 30, scale: 10
    t.decimal  "237826X53X734OSCE1",                         precision: 30, scale: 10
    t.decimal  "237826X53X734OSCE2",                         precision: 30, scale: 10
    t.decimal  "237826X53X734HistologySkills",               precision: 30, scale: 10
    t.decimal  "237826X53X734GeneticsPedigree",              precision: 30, scale: 10
    t.decimal  "237826X53X745Component1",                    precision: 30, scale: 10
    t.decimal  "237826X53X745Component2",                    precision: 30, scale: 10
    t.decimal  "237826X53X745Component3",                    precision: 30, scale: 10
    t.decimal  "237826X53X745Component4",                    precision: 30, scale: 10
    t.decimal  "237826X53X745Component5",                    precision: 30, scale: 10
    t.text     "237826X53X755ComponentFailed"
    t.text     "237826X53X755AreasOfDeficiency"
    t.text     "237826X53X755RetestResults"
    t.text     "237826X53X755RetestResultPNP"
    t.text     "237826X53X755NoOfPrevcompFails"
    t.text     "237826X53X755NoOfFailuresToDate"
    t.text     "237826X53X755LetterSent"
    t.text     "237826X53X755MSPBDiscussed"
    t.text     "237826X53X756ComponentFailed"
    t.text     "237826X53X756AreasOfDeficiency"
    t.text     "237826X53X756RetestResults"
    t.text     "237826X53X756RetestResultPNP"
    t.text     "237826X53X756NoOfPrevcompFails"
    t.text     "237826X53X756NoOfFailuresToDate"
    t.text     "237826X53X756LetterSent"
    t.text     "237826X53X756MSPBDiscussed"
    t.text     "237826X55X744CourseYear"
    t.text     "237826X55X744CourseName"
    t.decimal  "237826X55X737Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X55X737Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X55X737Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X55X737Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X55X737Week5MCQ",                      precision: 30, scale: 10
    t.text     "237826X55X738DroppedQuiz"
    t.text     "237826X55X738DroppedScore"
    t.decimal  "237826X55X739Week2",                         precision: 30, scale: 10
    t.decimal  "237826X55X739Week3",                         precision: 30, scale: 10
    t.decimal  "237826X55X740",                              precision: 30, scale: 10
    t.decimal  "237826X55X741",                              precision: 30, scale: 10
    t.decimal  "237826X55X742HistologySkills",               precision: 30, scale: 10
    t.decimal  "237826X55X742Microbiology",                  precision: 30, scale: 10
    t.decimal  "237826X55X742OSCE",                          precision: 30, scale: 10
    t.decimal  "237826X55X742Pathlogy",                      precision: 30, scale: 10
    t.decimal  "237826X55X746Component1",                    precision: 30, scale: 10
    t.decimal  "237826X55X746Component2",                    precision: 30, scale: 10
    t.decimal  "237826X55X746Component3",                    precision: 30, scale: 10
    t.decimal  "237826X55X746Component4",                    precision: 30, scale: 10
    t.decimal  "237826X55X746Component5",                    precision: 30, scale: 10
    t.text     "237826X55X757ComponentFailed"
    t.text     "237826X55X757AreasOfDeficiency"
    t.text     "237826X55X757RetestResults"
    t.text     "237826X55X757RetestResultPNP"
    t.text     "237826X55X757NoOfPrevcompFails"
    t.text     "237826X55X757NoOfFailuresToDate"
    t.text     "237826X55X757LetterSent"
    t.text     "237826X55X757MSPBDiscussed"
    t.text     "237826X55X758ComponentFailed"
    t.text     "237826X55X758AreasOfDeficiency"
    t.text     "237826X55X758RetestResults"
    t.text     "237826X55X758RetestResultPNP"
    t.text     "237826X55X758NoOfPrevcompFails"
    t.text     "237826X55X758NoOfFailuresToDate"
    t.text     "237826X55X758LetterSent"
    t.text     "237826X55X758MSPBDiscussed"
    t.text     "237826X56X747CourseYear"
    t.text     "237826X56X747CourseName"
    t.decimal  "237826X56X748Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X56X748Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X56X748Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X56X748Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "237826X56X748Week5MCQ",                      precision: 30, scale: 10
    t.text     "237826X56X749DroppedQuiz"
    t.text     "237826X56X749DroppedScore"
    t.decimal  "237826X56X750Anatomy",                       precision: 30, scale: 10
    t.decimal  "237826X56X750DermatologyImages",             precision: 30, scale: 10
    t.decimal  "237826X56X750Informatics",                   precision: 30, scale: 10
    t.decimal  "237826X56X750Week3CSAArithritis",            precision: 30, scale: 10
    t.decimal  "237826X56X751",                              precision: 30, scale: 10
    t.decimal  "237826X56X752",                              precision: 30, scale: 10
    t.decimal  "237826X56X753AnatomyFinal",                  precision: 30, scale: 10
    t.decimal  "237826X56X753Histology",                     precision: 30, scale: 10
    t.decimal  "237826X56X753ProblemRep",                    precision: 30, scale: 10
    t.decimal  "237826X56X753VisualImages",                  precision: 30, scale: 10
    t.decimal  "237826X56X754Component1",                    precision: 30, scale: 10
    t.decimal  "237826X56X754Component2",                    precision: 30, scale: 10
    t.decimal  "237826X56X754Component3",                    precision: 30, scale: 10
    t.decimal  "237826X56X754Component4",                    precision: 30, scale: 10
    t.decimal  "237826X56X754Component5",                    precision: 30, scale: 10
    t.text     "237826X56X759ComponentFailed"
    t.text     "237826X56X759AreasOfDeficiency"
    t.text     "237826X56X759RetestResults"
    t.text     "237826X56X759RetestResultPNP"
    t.text     "237826X56X759NoOfPrevcompFails"
    t.text     "237826X56X759NoOfFailuresToDate"
    t.text     "237826X56X759LetterSent"
    t.text     "237826X56X759MSPBDiscussed"
    t.text     "237826X56X760ComponentFailed"
    t.text     "237826X56X760AreasOfDeficiency"
    t.text     "237826X56X760RetestResults"
    t.text     "237826X56X760RetestResultPNP"
    t.text     "237826X56X760NoOfPrevcompFails"
    t.text     "237826X56X760NoOfFailuresToDate"
    t.text     "237826X56X760LetterSent"
    t.text     "237826X56X760MSPBDiscussed"
  end

  add_index "lime_survey_237826", ["token"], name: "idx_survey_token_237826_18182", using: :btree

  create_table "lime_survey_244784", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,  null: false
    t.string   "244784X73X1253InstructorKnowledge", limit: 5
    t.string   "244784X73X1253InstructorWellPrep",  limit: 5
    t.string   "244784X73X1253InstructorRate",      limit: 5
    t.text     "244784X73X1254"
    t.text     "244784X73X1255"
    t.text     "244784X73X1259"
    t.string   "244784X73X1256",                    limit: 255
    t.string   "244784X73X1257",                    limit: 255
    t.string   "244784X73X1258",                    limit: 255
  end

  add_index "lime_survey_244784", ["token"], name: "idx_survey_token_244784_41537", using: :btree

  create_table "lime_survey_255281", force: :cascade do |t|
    t.string   "token",                                    limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                            limit: 20,                            null: false
    t.text     "255281X109X1732FirstName"
    t.text     "255281X109X1732LastName"
    t.text     "255281X109X1732Address1"
    t.text     "255281X109X1732Address2"
    t.text     "255281X109X1732City"
    t.text     "255281X109X1732State"
    t.text     "255281X109X1732ZipCode"
    t.text     "255281X109X1732HomePhone"
    t.text     "255281X109X1732MobilePhone"
    t.datetime "255281X109X1733"
    t.string   "255281X109X1734",                          limit: 5
    t.text     "255281X109X1734other"
    t.string   "255281X109X1735",                          limit: 5
    t.text     "255281X109X1735other"
    t.string   "255281X109X1736",                          limit: 5
    t.string   "255281X109X17371",                         limit: 5
    t.string   "255281X109X17372",                         limit: 5
    t.string   "255281X109X17373",                         limit: 5
    t.string   "255281X109X17374",                         limit: 5
    t.string   "255281X109X17375",                         limit: 5
    t.text     "255281X109X1737other"
    t.string   "255281X109X1738",                          limit: 5
    t.string   "255281X109X1752",                          limit: 1
    t.text     "255281X109X1739Child1_Age1"
    t.text     "255281X109X1739Child2_Age1"
    t.text     "255281X109X1739Child3_Age1"
    t.text     "255281X109X1739Child4_Age1"
    t.text     "255281X109X1739Child5_Age1"
    t.text     "255281X109X1740City"
    t.text     "255281X109X1740State"
    t.text     "255281X109X1740Country"
    t.text     "255281X109X1741City"
    t.text     "255281X109X1741State"
    t.text     "255281X109X1741Country"
    t.text     "255281X109X1753Hobby1"
    t.text     "255281X109X1753Hobby2"
    t.text     "255281X109X1753Hobby3"
    t.decimal  "255281X110X1742",                                      precision: 30, scale: 10
    t.text     "255281X110X1743Row1_Institution"
    t.text     "255281X110X1743Row1_DegreeAttained"
    t.text     "255281X110X1743Row1_MajorAreaStudy"
    t.text     "255281X110X1743Row1_MinorAreaStudy"
    t.text     "255281X110X1743Row1_YrGrad"
    t.text     "255281X110X1743Row1_ScienceCoursesHrs"
    t.text     "255281X110X1743Row1_ScienceCoursesGPA"
    t.text     "255281X110X1743Row1_OverallGPA"
    t.text     "255281X110X1743Row2_Institution"
    t.text     "255281X110X1743Row2_DegreeAttained"
    t.text     "255281X110X1743Row2_MajorAreaStudy"
    t.text     "255281X110X1743Row2_MinorAreaStudy"
    t.text     "255281X110X1743Row2_YrGrad"
    t.text     "255281X110X1743Row2_ScienceCoursesHrs"
    t.text     "255281X110X1743Row2_ScienceCoursesGPA"
    t.text     "255281X110X1743Row2_OverallGPA"
    t.text     "255281X110X1743Row3_Institution"
    t.text     "255281X110X1743Row3_DegreeAttained"
    t.text     "255281X110X1743Row3_MajorAreaStudy"
    t.text     "255281X110X1743Row3_MinorAreaStudy"
    t.text     "255281X110X1743Row3_YrGrad"
    t.text     "255281X110X1743Row3_ScienceCoursesHrs"
    t.text     "255281X110X1743Row3_ScienceCoursesGPA"
    t.text     "255281X110X1743Row3_OverallGPA"
    t.text     "255281X110X1743Row4_Institution"
    t.text     "255281X110X1743Row4_DegreeAttained"
    t.text     "255281X110X1743Row4_MajorAreaStudy"
    t.text     "255281X110X1743Row4_MinorAreaStudy"
    t.text     "255281X110X1743Row4_YrGrad"
    t.text     "255281X110X1743Row4_ScienceCoursesHrs"
    t.text     "255281X110X1743Row4_ScienceCoursesGPA"
    t.text     "255281X110X1743Row4_OverallGPA"
    t.string   "255281X110X1754",                          limit: 255
    t.text     "255281X110X1744Row1_YrMCAT"
    t.text     "255281X110X1744Row1_PhsySciences"
    t.text     "255281X110X1744Row1_VerbalReasoning"
    t.text     "255281X110X1744Row1_BioSciences"
    t.text     "255281X110X1744Row1_MCATTotScore"
    t.text     "255281X110X1744Row2_YrMCAT"
    t.text     "255281X110X1744Row2_PhsySciences"
    t.text     "255281X110X1744Row2_VerbalReasoning"
    t.text     "255281X110X1744Row2_BioSciences"
    t.text     "255281X110X1744Row2_MCATTotScore"
    t.text     "255281X110X1744Row3_YrMCAT"
    t.text     "255281X110X1744Row3_PhsySciences"
    t.text     "255281X110X1744Row3_VerbalReasoning"
    t.text     "255281X110X1744Row3_BioSciences"
    t.text     "255281X110X1744Row3_MCATTotScore"
    t.text     "255281X110X1745Row1_YrMCAT"
    t.text     "255281X110X1745Row1_ChemPhyBioSys"
    t.text     "255281X110X1745Row1_CriticalAnalysis"
    t.text     "255281X110X1745Row1_BioFoundOfLivingSys"
    t.text     "255281X110X1745Row1_PsychSocBioFoundOfBe"
    t.text     "255281X110X1745Row1_MCATTotScore"
    t.text     "255281X110X1745Row2_YrMCAT"
    t.text     "255281X110X1745Row2_ChemPhyBioSys"
    t.text     "255281X110X1745Row2_CriticalAnalysis"
    t.text     "255281X110X1745Row2_BioFoundOfLivingSys"
    t.text     "255281X110X1745Row2_PsychSocBioFoundOfBe"
    t.text     "255281X110X1745Row2_MCATTotScore"
    t.text     "255281X110X1745Row3_YrMCAT"
    t.text     "255281X110X1745Row3_ChemPhyBioSys"
    t.text     "255281X110X1745Row3_CriticalAnalysis"
    t.text     "255281X110X1745Row3_BioFoundOfLivingSys"
    t.text     "255281X110X1745Row3_PsychSocBioFoundOfBe"
    t.text     "255281X110X1745Row3_MCATTotScore"
    t.string   "255281X110X1746",                          limit: 5
    t.text     "255281X110X1747Row1_HealthcareSetting"
    t.text     "255281X110X1747Row1_CountryServed"
    t.text     "255281X110X1747Row1_Role"
    t.text     "255281X110X1747Row1_InclusiveYrs"
    t.text     "255281X110X1747Row2_HealthcareSetting"
    t.text     "255281X110X1747Row2_CountryServed"
    t.text     "255281X110X1747Row2_Role"
    t.text     "255281X110X1747Row2_InclusiveYrs"
    t.text     "255281X110X1747Row3_HealthcareSetting"
    t.text     "255281X110X1747Row3_CountryServed"
    t.text     "255281X110X1747Row3_Role"
    t.text     "255281X110X1747Row3_InclusiveYrs"
    t.text     "255281X110X1755Experience1"
    t.text     "255281X110X1755Experience2"
    t.text     "255281X110X1755Experience3"
    t.string   "255281X110X1748",                          limit: 5
    t.string   "255281X110X17491",                         limit: 5
    t.string   "255281X110X17492",                         limit: 5
    t.string   "255281X110X17493",                         limit: 5
    t.string   "255281X110X17494",                         limit: 5
    t.string   "255281X110X17495",                         limit: 5
    t.string   "255281X110X17496",                         limit: 5
    t.string   "255281X110X17497",                         limit: 5
    t.string   "255281X110X17498",                         limit: 5
    t.string   "255281X110X17499",                         limit: 5
    t.string   "255281X110X174910",                        limit: 5
    t.string   "255281X110X174911",                        limit: 5
    t.string   "255281X110X174912",                        limit: 5
    t.string   "255281X110X174913",                        limit: 5
    t.string   "255281X110X174914",                        limit: 5
    t.string   "255281X110X174915",                        limit: 5
    t.string   "255281X110X174916",                        limit: 5
    t.string   "255281X110X174917",                        limit: 5
    t.string   "255281X110X174918",                        limit: 5
    t.string   "255281X110X174919",                        limit: 5
    t.string   "255281X110X174920",                        limit: 5
    t.string   "255281X110X174921",                        limit: 5
    t.string   "255281X110X174922",                        limit: 5
    t.string   "255281X110X174923",                        limit: 5
    t.string   "255281X111X17501",                         limit: 5
    t.string   "255281X111X17502",                         limit: 5
    t.string   "255281X111X17503",                         limit: 5
    t.string   "255281X111X17504",                         limit: 5
    t.string   "255281X111X17505",                         limit: 5
    t.string   "255281X111X17506",                         limit: 5
    t.string   "255281X111X17507",                         limit: 5
    t.decimal  "255281X111X1751NoOfAdults",                            precision: 30, scale: 10
    t.decimal  "255281X111X1751NoOfChildrens",                         precision: 30, scale: 10
  end

  add_index "lime_survey_255281", ["token"], name: "idx_survey_token_255281_36373", using: :btree

  create_table "lime_survey_286313", force: :cascade do |t|
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",            limit: 20, null: false
    t.text     "286313X5X563StudentEmail"
    t.text     "286313X5X563StudentName"
    t.text     "286313X5X563StudentID"
    t.text     "286313X5X563CoachEmail"
    t.text     "286313X5X563CoachName"
    t.string   "286313X5X103SQ001",        limit: 5
    t.string   "286313X5X103SQ002",        limit: 5
    t.string   "286313X5X103SQ003",        limit: 5
    t.string   "286313X5X103SQ004",        limit: 5
    t.string   "286313X5X103SQ005",        limit: 5
    t.string   "286313X5X103SQ006",        limit: 5
    t.string   "286313X5X103SQ007",        limit: 5
    t.string   "286313X5X103SQ008",        limit: 5
    t.string   "286313X5X103SQ009",        limit: 5
    t.string   "286313X5X103SQ010",        limit: 5
    t.string   "286313X5X103SQ011",        limit: 5
    t.string   "286313X5X103SQ012",        limit: 5
  end

  create_table "lime_survey_312732", force: :cascade do |t|
    t.string   "token",           limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",   limit: 20,  null: false
    t.string   "312732X121X1959", limit: 5
    t.string   "312732X121X1960", limit: 255
  end

  add_index "lime_survey_312732", ["token"], name: "idx_survey_token_312732_46018", using: :btree

  create_table "lime_survey_352355", force: :cascade do |t|
    t.string   "token",                            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                    limit: 20,                           null: false
    t.text     "352355X65X1071StudentYear"
    t.text     "352355X65X1071StudentEmail"
    t.text     "352355X65X1071StudentName"
    t.text     "352355X65X1071CoachEmail"
    t.text     "352355X65X1071CoachName"
    t.text     "352355X66X1072CourseYear"
    t.text     "352355X66X1072CourseName"
    t.decimal  "352355X66X1073Week1MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week2MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week3MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week4MCQ",                      precision: 30, scale: 10
    t.decimal  "352355X66X1073Week5MCQ",                      precision: 30, scale: 10
    t.text     "352355X66X1074DroppedQuiz"
    t.text     "352355X66X1074DroppedScore"
    t.decimal  "352355X66X1075Anatomy",                       precision: 30, scale: 10
    t.decimal  "352355X66X1075DermatologyImages",             precision: 30, scale: 10
    t.decimal  "352355X66X1075Informatics",                   precision: 30, scale: 10
    t.decimal  "352355X66X1075Week3CSAArithritis",            precision: 30, scale: 10
    t.decimal  "352355X66X1076",                              precision: 30, scale: 10
    t.decimal  "352355X66X1077",                              precision: 30, scale: 10
    t.decimal  "352355X66X1078AnatomyFinal",                  precision: 30, scale: 10
    t.decimal  "352355X66X1078Histology",                     precision: 30, scale: 10
    t.decimal  "352355X66X1078ProblemRep",                    precision: 30, scale: 10
    t.decimal  "352355X66X1078VisualImages",                  precision: 30, scale: 10
    t.decimal  "352355X66X1079Component1",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component2",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component3",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component4",                    precision: 30, scale: 10
    t.decimal  "352355X66X1079Component5",                    precision: 30, scale: 10
    t.text     "352355X66X1449"
    t.integer  "352355X66X1449_filecount"
  end

  add_index "lime_survey_352355", ["token"], name: "idx_survey_token_352355_28503", using: :btree

  create_table "lime_survey_377817", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,                           null: false
    t.text     "377817X70X1200StudentYear"
    t.text     "377817X70X1200StudentEmail"
    t.text     "377817X70X1200StudentName"
    t.text     "377817X70X1200CoachEmail"
    t.text     "377817X70X1200CoachName"
    t.text     "377817X71X1201CourseYear"
    t.text     "377817X71X1201CourseName"
    t.decimal  "377817X71X1202Week1MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week2MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week4MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week5MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week6MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week8MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week9MCQ",                       precision: 30, scale: 10
    t.decimal  "377817X71X1202Week10MCQ",                      precision: 30, scale: 10
    t.text     "377817X71X1203DroppedQuiz"
    t.text     "377817X71X1203DroppedScore"
    t.decimal  "377817X71X1204FOMA",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA7",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA8",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA9",                           precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA10",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA11",                          precision: 30, scale: 10
    t.decimal  "377817X71X1204CSA12",                          precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockCardiac",              precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockRenal",                precision: 30, scale: 10
    t.decimal  "377817X71X1205FinalBlockPulmonary",            precision: 30, scale: 10
    t.decimal  "377817X71X1206",                               precision: 30, scale: 10
    t.decimal  "377817X71X1207OSCE",                           precision: 30, scale: 10
    t.decimal  "377817X71X1207Histology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Pathology",                      precision: 30, scale: 10
    t.decimal  "377817X71X1207Microbiology",                   precision: 30, scale: 10
    t.decimal  "377817X71X1208Component1",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component2",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component3",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component4",                     precision: 30, scale: 10
    t.decimal  "377817X71X1208Component5",                     precision: 30, scale: 10
    t.text     "377817X71X1450"
    t.integer  "377817X71X1450_filecount"
  end

  add_index "lime_survey_377817", ["token"], name: "idx_survey_token_377817_27181", using: :btree

  create_table "lime_survey_427934", force: :cascade do |t|
    t.string   "token",               limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",       limit: 20,  null: false
    t.datetime "startdate",                       null: false
    t.datetime "datestamp",                       null: false
    t.string   "427934X82X1344",      limit: 255
    t.string   "427934X82X1343SQ001", limit: 5
    t.string   "427934X82X1343SQ002", limit: 5
    t.string   "427934X82X1343SQ003", limit: 5
    t.string   "427934X82X1343SQ004", limit: 5
    t.string   "427934X82X1343SQ005", limit: 5
    t.string   "427934X82X1343SQ006", limit: 5
    t.string   "427934X82X1343SQ007", limit: 5
    t.string   "427934X82X1343SQ008", limit: 5
    t.string   "427934X82X1343SQ009", limit: 5
    t.string   "427934X82X1343SQ010", limit: 5
    t.string   "427934X82X1343SQ011", limit: 5
    t.string   "427934X82X1343SQ012", limit: 5
  end

  add_index "lime_survey_427934", ["token"], name: "idx_survey_token_427934_41069", using: :btree

  create_table "lime_survey_427934_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "427934X82time"
    t.float "427934X82X1344time"
    t.float "427934X82X1343time"
  end

  create_table "lime_survey_444625", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,  null: false
    t.string   "444625X78X1291InstructorKnowledge", limit: 5
    t.string   "444625X78X1291InstructorWellPrep",  limit: 5
    t.string   "444625X78X1291InstructorRate",      limit: 5
    t.text     "444625X78X1292"
    t.text     "444625X78X1293"
    t.string   "444625X78X1294",                    limit: 255
    t.string   "444625X78X1295",                    limit: 255
    t.string   "444625X78X1296",                    limit: 255
  end

  add_index "lime_survey_444625", ["token"], name: "idx_survey_token_444625_23702", using: :btree

  create_table "lime_survey_467979", force: :cascade do |t|
    t.string   "token",                       limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",               limit: 20,                           null: false
    t.text     "467979X120X1924StudentYear"
    t.text     "467979X120X1924StudentEmail"
    t.text     "467979X120X1924StudentName"
    t.text     "467979X120X1924CoachEmail"
    t.text     "467979X120X1924CoachName"
    t.text     "467979X119X1925CourseYear"
    t.text     "467979X119X1925CourseName"
    t.decimal  "467979X119X1918Week1MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week2MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week3MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week4MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week5MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week6MCQ",                precision: 30, scale: 10
    t.decimal  "467979X119X1918Week7MCQ",                precision: 30, scale: 10
    t.text     "467979X119X1923DroppedQuiz"
    t.text     "467979X119X1923DroppedScore"
    t.decimal  "467979X119X1919CSA1",                    precision: 30, scale: 10
    t.decimal  "467979X119X1919CSA2",                    precision: 30, scale: 10
    t.decimal  "467979X119X1919CSA3",                    precision: 30, scale: 10
    t.decimal  "467979X119X1919CSA4",                    precision: 30, scale: 10
    t.decimal  "467979X119X1919CSA5",                    precision: 30, scale: 10
    t.decimal  "467979X119X1920",                        precision: 30, scale: 10
    t.decimal  "467979X119X1921",                        precision: 30, scale: 10
    t.decimal  "467979X119X1922OSCE",                    precision: 30, scale: 10
    t.decimal  "467979X119X1922Histology",               precision: 30, scale: 10
    t.decimal  "467979X119X1922Anatomy",                 precision: 30, scale: 10
    t.decimal  "467979X119X1922Microbiology",            precision: 30, scale: 10
    t.decimal  "467979X119X1922MET",                     precision: 30, scale: 10
    t.decimal  "467979X119X1926Component1",              precision: 30, scale: 10
    t.decimal  "467979X119X1926Component2",              precision: 30, scale: 10
    t.decimal  "467979X119X1926Component3",              precision: 30, scale: 10
    t.decimal  "467979X119X1926Component4",              precision: 30, scale: 10
    t.decimal  "467979X119X1926Component5",              precision: 30, scale: 10
    t.text     "467979X119X1927"
    t.integer  "467979X119X1927_filecount"
  end

  add_index "lime_survey_467979", ["token"], name: "idx_survey_token_467979_33811", using: :btree

  create_table "lime_survey_515866", force: :cascade do |t|
    t.string   "token",            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",    limit: 20, null: false
    t.datetime "startdate",                   null: false
    t.datetime "datestamp",                   null: false
    t.string   "515866X1X1SQ001",  limit: 5
    t.string   "515866X1X2SQ001",  limit: 5
    t.string   "515866X1X3",       limit: 5
    t.text     "515866X1X3other"
    t.string   "515866X1X4",       limit: 1
    t.string   "515866X1X5",       limit: 5
    t.text     "515866X1X5other"
    t.string   "515866X1X6SQ001",  limit: 5
    t.string   "515866X1X6SQ002",  limit: 5
    t.string   "515866X1X6SQ003",  limit: 5
    t.string   "515866X1X6SQ004",  limit: 5
    t.string   "515866X1X6SQ005",  limit: 5
    t.string   "515866X1X6SQ006",  limit: 5
    t.string   "515866X1X6SQ007",  limit: 5
    t.string   "515866X1X6SQ008",  limit: 5
    t.string   "515866X1X6SQ009",  limit: 5
    t.string   "515866X1X7SQ001",  limit: 5
    t.string   "515866X1X8SQ001",  limit: 5
    t.string   "515866X1X8SQ002",  limit: 5
    t.string   "515866X1X8SQ003",  limit: 5
    t.string   "515866X1X8SQ004",  limit: 5
    t.string   "515866X1X8SQ005",  limit: 5
    t.string   "515866X1X8SQ006",  limit: 5
    t.string   "515866X1X9",       limit: 5
    t.string   "515866X1X10",      limit: 5
    t.text     "515866X1X10other"
    t.text     "515866X1X11"
  end

  add_index "lime_survey_515866", ["token"], name: "idx_survey_token_515866_44125", using: :btree

  create_table "lime_survey_515866_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "515866X1time"
    t.float "515866X1X1time"
    t.float "515866X1X2time"
    t.float "515866X1X3time"
    t.float "515866X1X4time"
    t.float "515866X1X5time"
    t.float "515866X1X6time"
    t.float "515866X1X7time"
    t.float "515866X1X8time"
    t.float "515866X1X9time"
    t.float "515866X1X10time"
    t.float "515866X1X11time"
  end

  create_table "lime_survey_519686", force: :cascade do |t|
    t.string   "token",                      limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",              limit: 20,                           null: false
    t.text     "519686X67X1125StudentYear"
    t.text     "519686X67X1125StudentEmail"
    t.text     "519686X67X1125StudentName"
    t.text     "519686X67X1125CoachEmail"
    t.text     "519686X67X1125CoachName"
    t.text     "519686X67X1125Course"
    t.decimal  "519686X67X1124Comp1",                   precision: 30, scale: 10
    t.decimal  "519686X67X1124Comp2",                   precision: 30, scale: 10
    t.decimal  "519686X67X1124Comp3",                   precision: 30, scale: 10
    t.decimal  "519686X67X1124Comp4",                   precision: 30, scale: 10
    t.decimal  "519686X67X1124Comp5",                   precision: 30, scale: 10
  end

  add_index "lime_survey_519686", ["token"], name: "idx_survey_token_519686_12720", using: :btree

  create_table "lime_survey_563811", force: :cascade do |t|
    t.string   "token",             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",     limit: 20,                            null: false
    t.string   "563811X20X235",     limit: 255
    t.decimal  "563811X20X342FPEB",             precision: 30, scale: 10
    t.decimal  "563811X20X342HIST",             precision: 30, scale: 10
    t.decimal  "563811X20X342PPI",              precision: 30, scale: 10
    t.decimal  "563811X20X342PE",               precision: 30, scale: 10
  end

  add_index "lime_survey_563811", ["token"], name: "idx_survey_token_563811_10246", using: :btree

  create_table "lime_survey_619823", force: :cascade do |t|
    t.string   "token",               limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",       limit: 20,  null: false
    t.string   "619823X72X1244SQ001", limit: 5
    t.string   "619823X72X1244SQ002", limit: 5
    t.string   "619823X72X1244SQ003", limit: 5
    t.text     "619823X72X1245"
    t.text     "619823X72X1246"
    t.string   "619823X72X1247",      limit: 255
    t.string   "619823X72X1248",      limit: 255
    t.string   "619823X72X1249",      limit: 255
  end

  add_index "lime_survey_619823", ["token"], name: "idx_survey_token_619823_4612", using: :btree

  create_table "lime_survey_624522", force: :cascade do |t|
    t.string   "token",                          limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                  limit: 20,                           null: false
    t.text     "624522X63X1008StudentYear"
    t.text     "624522X63X1008StudentEmail"
    t.text     "624522X63X1008StudentName"
    t.text     "624522X63X1008CoachEmail"
    t.text     "624522X63X1008CoachName"
    t.text     "624522X62X1009CourseYear"
    t.text     "624522X62X1009CourseName"
    t.decimal  "624522X62X1002Week1MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week2MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week3MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week4MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week5MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week6MCQ",                    precision: 30, scale: 10
    t.decimal  "624522X62X1002Week7MCQ",                    precision: 30, scale: 10
    t.text     "624522X62X1007DroppedQuiz"
    t.text     "624522X62X1007DroppedScore"
    t.decimal  "624522X62X1003Week2",                       precision: 30, scale: 10
    t.decimal  "624522X62X1003Week4",                       precision: 30, scale: 10
    t.decimal  "624522X62X1003Week6",                       precision: 30, scale: 10
    t.decimal  "624522X62X1004",                            precision: 30, scale: 10
    t.decimal  "624522X62X1005",                            precision: 30, scale: 10
    t.decimal  "624522X62X1006OSCE1",                       precision: 30, scale: 10
    t.decimal  "624522X62X1006OSCE2",                       precision: 30, scale: 10
    t.decimal  "624522X62X1006HistologySkills",             precision: 30, scale: 10
    t.decimal  "624522X62X1006GeneticsPedigree",            precision: 30, scale: 10
    t.decimal  "624522X62X1010Component1",                  precision: 30, scale: 10
    t.decimal  "624522X62X1010Component2",                  precision: 30, scale: 10
    t.decimal  "624522X62X1010Component3",                  precision: 30, scale: 10
    t.decimal  "624522X62X1010Component4",                  precision: 30, scale: 10
    t.decimal  "624522X62X1010Component5",                  precision: 30, scale: 10
    t.text     "624522X62X1445"
    t.integer  "624522X62X1445_filecount"
  end

  add_index "lime_survey_624522", ["token"], name: "idx_survey_token_624522_45381", using: :btree

  create_table "lime_survey_677958", force: :cascade do |t|
    t.string   "token",                       limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",               limit: 20,                           null: false
    t.text     "677958X124X1969StudentYear"
    t.text     "677958X124X1969StudentEmail"
    t.text     "677958X124X1969StudentName"
    t.text     "677958X124X1969CoachEmail"
    t.text     "677958X124X1969CoachName"
    t.text     "677958X123X1970CourseYear"
    t.text     "677958X123X1970CourseName"
    t.decimal  "677958X123X1963Week1MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week2MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week3MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week4MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week5MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week6MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week7MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week8MCQ",                precision: 30, scale: 10
    t.decimal  "677958X123X1963Week9MCQ",                precision: 30, scale: 10
    t.text     "677958X123X1968DroppedQuiz"
    t.text     "677958X123X1968DroppedScore"
    t.decimal  "677958X123X1964CSA1",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA2",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA3",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA4",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA5",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA6",                    precision: 30, scale: 10
    t.decimal  "677958X123X1964CSA7",                    precision: 30, scale: 10
    t.decimal  "677958X123X1965",                        precision: 30, scale: 10
    t.decimal  "677958X123X1966",                        precision: 30, scale: 10
    t.decimal  "677958X123X1967Neuro",                   precision: 30, scale: 10
    t.decimal  "677958X123X1967Histology",               precision: 30, scale: 10
    t.decimal  "677958X123X1967Anatomy",                 precision: 30, scale: 10
    t.decimal  "677958X123X1967GrossAnatomy",            precision: 30, scale: 10
    t.decimal  "677958X123X1971Component1",              precision: 30, scale: 10
    t.decimal  "677958X123X1971Component2",              precision: 30, scale: 10
    t.decimal  "677958X123X1971Component3",              precision: 30, scale: 10
    t.decimal  "677958X123X1971Component4",              precision: 30, scale: 10
    t.decimal  "677958X123X1971Component5",              precision: 30, scale: 10
    t.text     "677958X123X1972"
    t.integer  "677958X123X1972_filecount"
  end

  add_index "lime_survey_677958", ["token"], name: "idx_survey_token_677958_26641", using: :btree

  create_table "lime_survey_763739", force: :cascade do |t|
    t.string   "token",                            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                    limit: 20, null: false
    t.text     "763739X4X556StudentEmail"
    t.text     "763739X4X556StudentName"
    t.text     "763739X4X556StudentID"
    t.text     "763739X4X556CoachEmail"
    t.text     "763739X4X556CoachName"
    t.string   "763739X25X77RateYourHealth4Weeks", limit: 5
    t.string   "763739X25X78ProblemsWalking",      limit: 5
    t.string   "763739X25X78DifficultDailyWork",   limit: 5
    t.string   "763739X25X78EmotionsProb",         limit: 5
    t.string   "763739X25X78PersonalProbUsualWor", limit: 5
    t.string   "763739X25X79BodilyPain",           limit: 5
    t.string   "763739X25X80Past4WeekEnergyLevel", limit: 5
    t.string   "763739X25X81BotheredEmotionalPro", limit: 5
    t.string   "763739X26X82BennUpset",            limit: 5
    t.string   "763739X26X82UnableControl",        limit: 5
    t.string   "763739X26X82FeltNervous",          limit: 5
    t.string   "763739X26X82FeltConfident",        limit: 5
    t.string   "763739X26X82FeltGoingYourWay",     limit: 5
    t.string   "763739X26X82CouldNotCope",         limit: 5
    t.string   "763739X26X82AbleToControl",        limit: 5
    t.string   "763739X26X82OnTopOfThings",        limit: 5
    t.string   "763739X26X82BeenAngered",          limit: 5
    t.string   "763739X26X82PilingUpHigh",         limit: 5
  end

  add_index "lime_survey_763739", ["token"], name: "idx_survey_token_763739_1407", using: :btree

  create_table "lime_survey_777632", force: :cascade do |t|
    t.string   "token",                               limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                       limit: 20,  null: false
    t.datetime "startdate",                                       null: false
    t.datetime "datestamp",                                       null: false
    t.string   "777632X105X1599",                     limit: 255
    t.text     "777632X102X1598StudentEmail"
    t.text     "777632X102X1598StudentName"
    t.text     "777632X102X1598StudentID"
    t.text     "777632X102X1598CoachEmail"
    t.text     "777632X102X1598CoachName"
    t.string   "777632X103X1592RateYourHealth4Weeks", limit: 5
    t.string   "777632X103X1593ProblemsWalking",      limit: 5
    t.string   "777632X103X1593DifficultDailyWork",   limit: 5
    t.string   "777632X103X1593EmotionsProb",         limit: 5
    t.string   "777632X103X1593PersonalProbUsualWor", limit: 5
    t.string   "777632X103X1594BodilyPain",           limit: 5
    t.string   "777632X103X1595Past4WeekEnergyLevel", limit: 5
    t.string   "777632X103X1596BotheredEmotionalPro", limit: 5
    t.string   "777632X104X1597BennUpset",            limit: 5
    t.string   "777632X104X1597UnableControl",        limit: 5
    t.string   "777632X104X1597FeltNervous",          limit: 5
    t.string   "777632X104X1597FeltConfident",        limit: 5
    t.string   "777632X104X1597FeltGoingYourWay",     limit: 5
    t.string   "777632X104X1597CouldNotCope",         limit: 5
    t.string   "777632X104X1597AbleToControl",        limit: 5
    t.string   "777632X104X1597OnTopOfThings",        limit: 5
    t.string   "777632X104X1597BeenAngered",          limit: 5
    t.string   "777632X104X1597PilingUpHigh",         limit: 5
  end

  add_index "lime_survey_777632", ["token"], name: "idx_survey_token_777632_1953", using: :btree

  create_table "lime_survey_777632_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "777632X105time"
    t.float "777632X105X1599time"
    t.float "777632X102time"
    t.float "777632X102X1598time"
    t.float "777632X103time"
    t.float "777632X103X1592time"
    t.float "777632X103X1593time"
    t.float "777632X103X1594time"
    t.float "777632X103X1595time"
    t.float "777632X103X1596time"
    t.float "777632X104time"
    t.float "777632X104X1597time"
  end

  create_table "lime_survey_777786", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.string   "777786X122X1961",                    limit: 5
    t.string   "777786X122X1962",                    limit: 255
    t.string   "777786X89X1402Clarify",              limit: 5
    t.string   "777786X89X1402Represents",           limit: 5
    t.string   "777786X89X1402Responsible",          limit: 5
    t.string   "777786X89X1402Inspire",              limit: 5
    t.string   "777786X89X1402Determine",            limit: 5
    t.string   "777786X89X1402Active",               limit: 5
    t.string   "777786X89X1402Honest",               limit: 5
    t.string   "777786X90X1403SeekAndHear",          limit: 5
    t.string   "777786X90X1403LearnAbout",           limit: 5
    t.string   "777786X90X1403ConveyAny",            limit: 5
    t.string   "777786X90X1403DevelopAShared",       limit: 5
    t.string   "777786X90X1403SpecificMeasurable",   limit: 5
    t.string   "777786X90X1403WorkWithYourStudent",  limit: 5
    t.string   "777786X90X1403OrganizeInterpret",    limit: 5
    t.string   "777786X90X1403DetermineTimelines",   limit: 5
    t.string   "777786X90X1403MonitorYourProgress",  limit: 5
    t.string   "777786X90X1403IdentifyProblems",     limit: 5
    t.string   "777786X90X1403SolveProblems",        limit: 5
    t.string   "777786X90X1403Characterize",         limit: 5
    t.string   "777786X91X1404RecognizePersFeeling", limit: 5
    t.string   "777786X91X1404AwareOfEmotions",      limit: 5
    t.string   "777786X91X1404InvestigateBehavior",  limit: 5
    t.string   "777786X91X1404ContradictoryFeeling", limit: 5
    t.string   "777786X91X1404ThinkingHabits",       limit: 5
    t.string   "777786X91X1404TrustingRelationship", limit: 5
    t.string   "777786X91X1404SafeLearning",         limit: 5
    t.string   "777786X91X1404Commitment",           limit: 5
    t.string   "777786X91X1404Affirm",               limit: 5
    t.string   "777786X91X1404AcceptFeedback",       limit: 5
    t.string   "777786X91X1404Stimulates",           limit: 5
    t.string   "777786X91X1404Encourage",            limit: 5
    t.string   "777786X91X1404EncourageProfDev",     limit: 5
    t.string   "777786X91X1404ConstructiveFeedback", limit: 5
    t.text     "777786X92X1405"
    t.text     "777786X92X1406"
    t.text     "777786X88X1400"
    t.text     "777786X88X1410"
    t.text     "777786X88X1409"
  end

  add_index "lime_survey_777786", ["token"], name: "idx_survey_token_777786_28283", using: :btree

  create_table "lime_survey_795667", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,  null: false
    t.string   "795667X75X1273InstructorKnowledge", limit: 5
    t.string   "795667X75X1273InstructorWellPrep",  limit: 5
    t.string   "795667X75X1273InstructorRate",      limit: 5
    t.text     "795667X75X1274"
    t.text     "795667X75X1275"
    t.text     "795667X75X1276"
    t.string   "795667X75X1277",                    limit: 255
    t.string   "795667X75X1278",                    limit: 255
    t.string   "795667X75X1279",                    limit: 255
  end

  add_index "lime_survey_795667", ["token"], name: "idx_survey_token_795667_32907", using: :btree

  create_table "lime_survey_834556", force: :cascade do |t|
    t.string   "token",                       limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",               limit: 20,  null: false
    t.datetime "startdate",                               null: false
    t.datetime "datestamp",                               null: false
    t.string   "834556X128X2020",             limit: 255
    t.text     "834556X126X2013"
    t.text     "834556X126X2014"
    t.text     "834556X126X2015"
    t.string   "834556X126X2016",             limit: 1
    t.text     "834556X126X2017"
    t.text     "834556X126X2018"
    t.string   "834556X127X2019SQ001",        limit: 5
    t.string   "834556X127X2019SQ002",        limit: 5
    t.string   "834556X127X2019SQ003",        limit: 5
    t.string   "834556X127X2019SQ004",        limit: 5
    t.string   "834556X127X2019SQ005",        limit: 5
    t.string   "834556X127X2019SQ006",        limit: 5
    t.string   "834556X127X2019SQ007",        limit: 5
    t.string   "834556X127X2019SQ008",        limit: 5
    t.string   "834556X127X2019SQ009",        limit: 5
    t.string   "834556X127X2019SQ010",        limit: 5
    t.string   "834556X127X2019SQ011",        limit: 5
    t.text     "834556X129X2032StudentYear"
    t.text     "834556X129X2032StudentEmail"
    t.text     "834556X129X2032StudentName"
    t.text     "834556X129X2032CoachEmail"
    t.text     "834556X129X2032CoachName"
  end

  add_index "lime_survey_834556", ["token"], name: "idx_survey_token_834556_36271", using: :btree

  create_table "lime_survey_834556_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "834556X128time"
    t.float "834556X128X2020time"
    t.float "834556X126time"
    t.float "834556X126X2013time"
    t.float "834556X126X2014time"
    t.float "834556X126X2015time"
    t.float "834556X126X2016time"
    t.float "834556X126X2017time"
    t.float "834556X126X2018time"
    t.float "834556X127time"
    t.float "834556X127X2019time"
    t.float "834556X129time"
    t.float "834556X129X2032time"
  end

  create_table "lime_survey_838243", force: :cascade do |t|
    t.string   "token",                      limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",              limit: 20,                           null: false
    t.text     "838243X81X1309StudentYear"
    t.text     "838243X81X1309StudentEmail"
    t.text     "838243X81X1309StudentName"
    t.text     "838243X81X1309CoachEmail"
    t.text     "838243X81X1309CoachName"
    t.text     "838243X80X1310CourseYear"
    t.text     "838243X80X1310CourseName"
    t.decimal  "838243X80X1303Week1MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week2MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week3MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week4MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week5MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week6MCQ",                precision: 30, scale: 10
    t.decimal  "838243X80X1303Week7MCQ",                precision: 30, scale: 10
    t.text     "838243X80X1308DroppedQuiz"
    t.text     "838243X80X1308DroppedScore"
    t.decimal  "838243X80X1304CSA1",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA2",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA3",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA4",                    precision: 30, scale: 10
    t.decimal  "838243X80X1304CSA5",                    precision: 30, scale: 10
    t.decimal  "838243X80X1305",                        precision: 30, scale: 10
    t.decimal  "838243X80X1306",                        precision: 30, scale: 10
    t.decimal  "838243X80X1307OSCE",                    precision: 30, scale: 10
    t.decimal  "838243X80X1307Histology",               precision: 30, scale: 10
    t.decimal  "838243X80X1307Anatomy",                 precision: 30, scale: 10
    t.decimal  "838243X80X1307Microbiology",            precision: 30, scale: 10
    t.decimal  "838243X80X1307MET",                     precision: 30, scale: 10
    t.decimal  "838243X80X1311Component1",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component2",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component3",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component4",              precision: 30, scale: 10
    t.decimal  "838243X80X1311Component5",              precision: 30, scale: 10
    t.text     "838243X80X1312"
    t.integer  "838243X80X1312_filecount"
  end

  add_index "lime_survey_838243", ["token"], name: "idx_survey_token_838243_9486", using: :btree

  create_table "lime_survey_887795", force: :cascade do |t|
    t.string   "token",                        limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                limit: 20,                           null: false
    t.text     "887795X58X888StudentYear"
    t.text     "887795X58X888StudentEmail"
    t.text     "887795X58X888StudentName"
    t.text     "887795X58X888CoachEmail"
    t.text     "887795X58X888CoachName"
    t.text     "887795X59X895CourseYear"
    t.text     "887795X59X895CourseName"
    t.decimal  "887795X59X889Week1MCQ",                   precision: 30, scale: 10
    t.decimal  "887795X59X889Week2MCQ",                   precision: 30, scale: 10
    t.decimal  "887795X59X889Week3MCQ",                   precision: 30, scale: 10
    t.decimal  "887795X59X889Week4MCQ",                   precision: 30, scale: 10
    t.decimal  "887795X59X889Week5MCQ",                   precision: 30, scale: 10
    t.text     "887795X59X890DroppedQuiz"
    t.text     "887795X59X890DroppedScore"
    t.decimal  "887795X59X891Week2",                      precision: 30, scale: 10
    t.decimal  "887795X59X891Week3",                      precision: 30, scale: 10
    t.decimal  "887795X59X892",                           precision: 30, scale: 10
    t.decimal  "887795X59X893",                           precision: 30, scale: 10
    t.decimal  "887795X59X894HistologySkills",            precision: 30, scale: 10
    t.decimal  "887795X59X894Microbiology",               precision: 30, scale: 10
    t.decimal  "887795X59X894OSCE",                       precision: 30, scale: 10
    t.decimal  "887795X59X894Pathlogy",                   precision: 30, scale: 10
    t.decimal  "887795X59X896Component1",                 precision: 30, scale: 10
    t.decimal  "887795X59X896Component2",                 precision: 30, scale: 10
    t.decimal  "887795X59X896Component3",                 precision: 30, scale: 10
    t.decimal  "887795X59X896Component4",                 precision: 30, scale: 10
    t.decimal  "887795X59X896Component5",                 precision: 30, scale: 10
    t.text     "887795X59X1447"
    t.integer  "887795X59X1447_filecount"
  end

  add_index "lime_survey_887795", ["token"], name: "idx_survey_token_887795_37480", using: :btree

  create_table "lime_survey_916752", force: :cascade do |t|
    t.string   "token",            limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",    limit: 20, null: false
    t.datetime "startdate",                   null: false
    t.datetime "datestamp",                   null: false
    t.string   "916752X2X30SQ001", limit: 5
    t.string   "916752X2X31",      limit: 5
    t.string   "916752X2X32",      limit: 1
    t.string   "916752X2X33",      limit: 5
    t.text     "916752X2X33other"
    t.string   "916752X2X34",      limit: 1
    t.string   "916752X2X35",      limit: 5
    t.text     "916752X2X35other"
    t.string   "916752X2X36",      limit: 1
    t.string   "916752X2X37",      limit: 5
    t.text     "916752X2X37other"
    t.string   "916752X2X381",     limit: 5
    t.string   "916752X2X382",     limit: 5
    t.string   "916752X2X383",     limit: 5
    t.string   "916752X2X384",     limit: 5
    t.string   "916752X2X385",     limit: 5
    t.string   "916752X2X386",     limit: 5
    t.string   "916752X2X387",     limit: 5
    t.string   "916752X2X388",     limit: 5
    t.text     "916752X2X38other"
    t.string   "916752X2X39SQ001", limit: 5
    t.string   "916752X2X40SQ001", limit: 5
    t.string   "916752X2X40SQ002", limit: 5
    t.string   "916752X2X40SQ003", limit: 5
    t.string   "916752X2X40SQ004", limit: 5
    t.string   "916752X2X40SQ005", limit: 5
    t.string   "916752X2X40SQ006", limit: 5
    t.string   "916752X2X41SQ001", limit: 5
    t.string   "916752X2X41SQ002", limit: 5
    t.string   "916752X2X41SQ003", limit: 5
    t.string   "916752X2X41SQ004", limit: 5
    t.string   "916752X2X41SQ005", limit: 5
    t.string   "916752X2X41SQ006", limit: 5
    t.text     "916752X2X42"
  end

  add_index "lime_survey_916752", ["token"], name: "idx_survey_token_916752_28174", using: :btree

  create_table "lime_survey_916752_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "916752X2time"
    t.float "916752X2X30time"
    t.float "916752X2X31time"
    t.float "916752X2X32time"
    t.float "916752X2X33time"
    t.float "916752X2X34time"
    t.float "916752X2X35time"
    t.float "916752X2X36time"
    t.float "916752X2X37time"
    t.float "916752X2X38time"
    t.float "916752X2X39time"
    t.float "916752X2X40time"
    t.float "916752X2X41time"
    t.float "916752X2X42time"
  end

  create_table "lime_survey_927695", force: :cascade do |t|
    t.string   "token",                              limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                      limit: 20,  null: false
    t.datetime "startdate",                                      null: false
    t.datetime "datestamp",                                      null: false
    t.text     "927695X83X1357"
    t.string   "927695X83X1358",                     limit: 255
    t.text     "927695X83X1364"
    t.text     "927695X83X1365"
    t.text     "927695X83X1366"
    t.text     "927695X83X1367"
    t.string   "927695X84X1359Clarify",              limit: 5
    t.string   "927695X84X1359Represents",           limit: 5
    t.string   "927695X84X1359Responsible",          limit: 5
    t.string   "927695X84X1359Inspire",              limit: 5
    t.string   "927695X84X1359Determine",            limit: 5
    t.string   "927695X84X1359Active",               limit: 5
    t.string   "927695X84X1359Honest",               limit: 5
    t.string   "927695X85X1360SeekAndHear",          limit: 5
    t.string   "927695X85X1360LearnAbout",           limit: 5
    t.string   "927695X85X1360AcceptAny",            limit: 5
    t.string   "927695X85X1360DevelopAShared",       limit: 5
    t.string   "927695X85X1360SpecificMeasurable",   limit: 5
    t.string   "927695X85X1360WorkWithYourCoach",    limit: 5
    t.string   "927695X85X1360DetermineTimelines",   limit: 5
    t.string   "927695X85X1360MonitorYourProgress",  limit: 5
    t.string   "927695X85X1360IdentifyProblems",     limit: 5
    t.string   "927695X85X1360SolveProblems",        limit: 5
    t.string   "927695X85X1360Characterize",         limit: 5
    t.string   "927695X86X1361RecognizePersFeeling", limit: 5
    t.string   "927695X86X1361AwareOfEmotions",      limit: 5
    t.string   "927695X86X1361InvestigateBehavior",  limit: 5
    t.string   "927695X86X1361PayAttention",         limit: 5
    t.string   "927695X86X1361MyThinkingHabits",     limit: 5
    t.string   "927695X86X1361TrustingRelationship", limit: 5
    t.string   "927695X86X1361SafeLearningEnv",      limit: 5
    t.string   "927695X86X1361Commitment",           limit: 5
    t.string   "927695X86X1361Affirms",              limit: 5
    t.string   "927695X86X1361WillingToAcceptFeedb", limit: 5
    t.string   "927695X86X1361esLearningPrStimulat", limit: 5
    t.string   "927695X86X1361Encourages",           limit: 5
    t.string   "927695X86X1361StimulatesProfDevelo", limit: 5
    t.string   "927695X86X1361StimulatesConstFeedb", limit: 5
    t.text     "927695X87X1362"
    t.text     "927695X87X1363"
  end

  add_index "lime_survey_927695", ["token"], name: "idx_survey_token_927695_12443", using: :btree

  create_table "lime_survey_927695_timings", force: :cascade do |t|
    t.float "interviewtime"
    t.float "927695X83time"
    t.float "927695X83X1357time"
    t.float "927695X83X1358time"
    t.float "927695X83X1364time"
    t.float "927695X83X1365time"
    t.float "927695X83X1366time"
    t.float "927695X83X1367time"
    t.float "927695X84time"
    t.float "927695X84X1359time"
    t.float "927695X85time"
    t.float "927695X85X1360time"
    t.float "927695X86time"
    t.float "927695X86X1361time"
    t.float "927695X87time"
    t.float "927695X87X1362time"
    t.float "927695X87X1363time"
  end

  create_table "lime_survey_931453", force: :cascade do |t|
    t.string   "token",                             limit: 36
    t.datetime "submitdate"
    t.integer  "lastpage"
    t.string   "startlanguage",                     limit: 20,  null: false
    t.string   "931453X74X1263InstructorKnowledge", limit: 5
    t.string   "931453X74X1263InstructorWellPrep",  limit: 5
    t.string   "931453X74X1263InstructorRate",      limit: 5
    t.text     "931453X74X1264"
    t.text     "931453X74X1265"
    t.text     "931453X74X1269"
    t.string   "931453X74X1266",                    limit: 255
    t.string   "931453X74X1267",                    limit: 255
    t.string   "931453X74X1268",                    limit: 255
  end

  add_index "lime_survey_931453", ["token"], name: "idx_survey_token_931453_37424", using: :btree

  create_table "lime_survey_links", id: false, force: :cascade do |t|
    t.string   "participant_id", limit: 50, null: false
    t.integer  "token_id",                  null: false
    t.integer  "survey_id",                 null: false
    t.datetime "date_created"
    t.datetime "date_invited"
    t.datetime "date_completed"
  end

  create_table "lime_survey_url_parameters", force: :cascade do |t|
    t.integer "sid",                   null: false
    t.string  "parameter",  limit: 50, null: false
    t.integer "targetqid"
    t.integer "targetsqid"
  end

  create_table "lime_surveys", primary_key: "sid", force: :cascade do |t|
    t.integer  "owner_id",                                                 null: false
    t.string   "admin",                    limit: 50
    t.string   "active",                   limit: 1,   default: "N",       null: false
    t.datetime "expires"
    t.datetime "startdate"
    t.string   "adminemail",               limit: 254
    t.string   "anonymized",               limit: 1,   default: "N",       null: false
    t.string   "faxto",                    limit: 20
    t.string   "format",                   limit: 1
    t.string   "savetimings",              limit: 1,   default: "N",       null: false
    t.string   "template",                 limit: 100, default: "default"
    t.string   "language",                 limit: 50
    t.string   "additional_languages",     limit: 255
    t.string   "datestamp",                limit: 1,   default: "N",       null: false
    t.string   "usecookie",                limit: 1,   default: "N",       null: false
    t.string   "allowregister",            limit: 1,   default: "N",       null: false
    t.string   "allowsave",                limit: 1,   default: "Y",       null: false
    t.integer  "autonumber_start",                     default: 0,         null: false
    t.string   "autoredirect",             limit: 1,   default: "N",       null: false
    t.string   "allowprev",                limit: 1,   default: "N",       null: false
    t.string   "printanswers",             limit: 1,   default: "N",       null: false
    t.string   "ipaddr",                   limit: 1,   default: "N",       null: false
    t.string   "refurl",                   limit: 1,   default: "N",       null: false
    t.date     "datecreated"
    t.string   "publicstatistics",         limit: 1,   default: "N",       null: false
    t.string   "publicgraphs",             limit: 1,   default: "N",       null: false
    t.string   "listpublic",               limit: 1,   default: "N",       null: false
    t.string   "htmlemail",                limit: 1,   default: "N",       null: false
    t.string   "sendconfirmation",         limit: 1,   default: "Y",       null: false
    t.string   "tokenanswerspersistence",  limit: 1,   default: "N",       null: false
    t.string   "assessments",              limit: 1,   default: "N",       null: false
    t.string   "usecaptcha",               limit: 1,   default: "N",       null: false
    t.string   "usetokens",                limit: 1,   default: "N",       null: false
    t.string   "bounce_email",             limit: 254
    t.text     "attributedescriptions"
    t.text     "emailresponseto"
    t.text     "emailnotificationto"
    t.integer  "tokenlength",                          default: 15,        null: false
    t.string   "showxquestions",           limit: 1,   default: "Y"
    t.string   "showgroupinfo",            limit: 1,   default: "B"
    t.string   "shownoanswer",             limit: 1,   default: "Y"
    t.string   "showqnumcode",             limit: 1,   default: "X"
    t.integer  "bouncetime"
    t.string   "bounceprocessing",         limit: 1,   default: "N"
    t.string   "bounceaccounttype",        limit: 4
    t.string   "bounceaccounthost",        limit: 200
    t.string   "bounceaccountpass",        limit: 100
    t.string   "bounceaccountencryption",  limit: 3
    t.string   "bounceaccountuser",        limit: 200
    t.string   "showwelcome",              limit: 1,   default: "Y"
    t.string   "showprogress",             limit: 1,   default: "Y"
    t.integer  "questionindex",                        default: 0,         null: false
    t.integer  "navigationdelay",                      default: 0,         null: false
    t.string   "nokeyboard",               limit: 1,   default: "N"
    t.string   "alloweditaftercompletion", limit: 1,   default: "N"
    t.string   "googleanalyticsstyle",     limit: 1
    t.string   "googleanalyticsapikey",    limit: 25
  end

  create_table "lime_surveys_languagesettings", id: false, force: :cascade do |t|
    t.integer "surveyls_survey_id",                                       null: false
    t.string  "surveyls_language",             limit: 45,  default: "en", null: false
    t.string  "surveyls_title",                limit: 200,                null: false
    t.text    "surveyls_description"
    t.text    "surveyls_welcometext"
    t.text    "surveyls_endtext"
    t.text    "surveyls_url"
    t.string  "surveyls_urldescription",       limit: 255
    t.string  "surveyls_email_invite_subj",    limit: 255
    t.text    "surveyls_email_invite"
    t.string  "surveyls_email_remind_subj",    limit: 255
    t.text    "surveyls_email_remind"
    t.string  "surveyls_email_register_subj",  limit: 255
    t.text    "surveyls_email_register"
    t.string  "surveyls_email_confirm_subj",   limit: 255
    t.text    "surveyls_email_confirm"
    t.integer "surveyls_dateformat",                       default: 1,    null: false
    t.text    "surveyls_attributecaptions"
    t.string  "email_admin_notification_subj", limit: 255
    t.text    "email_admin_notification"
    t.string  "email_admin_responses_subj",    limit: 255
    t.text    "email_admin_responses"
    t.integer "surveyls_numberformat",                     default: 0,    null: false
    t.text    "attachments"
  end

  create_table "lime_templates", primary_key: "folder", force: :cascade do |t|
    t.integer "creator", null: false
  end

  create_table "lime_tokens_224436", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_224436", ["token"], name: "idx_token_token_224436_14084", using: :btree

  create_table "lime_tokens_237826", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_237826", ["token"], name: "idx_token_token_237826_2965", using: :btree

  create_table "lime_tokens_244784", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_244784", ["token"], name: "idx_token_token_244784_22852", using: :btree

  create_table "lime_tokens_286313", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
  end

  add_index "lime_tokens_286313", ["token"], name: "idx_token_token_286313_34289", using: :btree

  create_table "lime_tokens_312732", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
    t.text     "attribute_4"
    t.text     "attribute_5"
    t.text     "attribute_6"
    t.text     "attribute_7"
  end

  add_index "lime_tokens_312732", ["token"], name: "idx_token_token_312732_19513", using: :btree

  create_table "lime_tokens_352355", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_352355", ["token"], name: "idx_token_token_352355_19909", using: :btree

  create_table "lime_tokens_377817", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_377817", ["token"], name: "idx_token_token_377817_19462", using: :btree

  create_table "lime_tokens_427934", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
    t.text     "attribute_4"
  end

  add_index "lime_tokens_427934", ["token"], name: "idx_token_token_427934_2056", using: :btree

  create_table "lime_tokens_444625", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_444625", ["token"], name: "idx_token_token_444625_3626", using: :btree

  create_table "lime_tokens_515866", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
  end

  add_index "lime_tokens_515866", ["token"], name: "idx_token_token_515866_30762", using: :btree

  create_table "lime_tokens_519686", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_519686", ["token"], name: "idx_token_token_519686_9911", using: :btree

  create_table "lime_tokens_563811", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_563811", ["token"], name: "idx_token_token_563811_11715", using: :btree

  create_table "lime_tokens_619823", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_619823", ["token"], name: "idx_token_token_619823_6870", using: :btree

  create_table "lime_tokens_624522", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_624522", ["token"], name: "idx_token_token_624522_1833", using: :btree

  create_table "lime_tokens_763739", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_763739", ["token"], name: "idx_token_token_763739_18570", using: :btree

  create_table "lime_tokens_777632", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
  end

  add_index "lime_tokens_777632", ["token"], name: "idx_token_token_777632_47135", using: :btree

  create_table "lime_tokens_777786", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
    t.text     "attribute_4"
    t.text     "attribute_5"
    t.text     "attribute_6"
    t.text     "attribute_7"
  end

  add_index "lime_tokens_777786", ["token"], name: "idx_token_token_777786_12999", using: :btree

  create_table "lime_tokens_795667", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_795667", ["token"], name: "idx_token_token_795667_16239", using: :btree

  create_table "lime_tokens_834556", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
  end

  add_index "lime_tokens_834556", ["token"], name: "idx_token_token_834556_15726", using: :btree

  create_table "lime_tokens_887795", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_887795", ["token"], name: "idx_token_token_887795_3404", using: :btree

  create_table "lime_tokens_916752", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
  end

  add_index "lime_tokens_916752", ["token"], name: "idx_token_token_916752_8848", using: :btree

  create_table "lime_tokens_927695", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
    t.text     "attribute_1"
    t.text     "attribute_2"
    t.text     "attribute_3"
    t.text     "attribute_4"
    t.text     "attribute_5"
  end

  add_index "lime_tokens_927695", ["token"], name: "idx_token_token_927695_21724", using: :btree

  create_table "lime_tokens_931453", primary_key: "tid", force: :cascade do |t|
    t.string   "participant_id", limit: 50
    t.string   "firstname",      limit: 150
    t.string   "lastname",       limit: 150
    t.string   "email",          limit: 254
    t.text     "emailstatus"
    t.string   "token",          limit: 35
    t.string   "language",       limit: 25
    t.string   "blacklisted",    limit: 17
    t.string   "sent",           limit: 17,  default: "N"
    t.string   "remindersent",   limit: 17,  default: "N"
    t.integer  "remindercount",              default: 0
    t.string   "completed",      limit: 17,  default: "N"
    t.integer  "usesleft",                   default: 1
    t.datetime "validfrom"
    t.datetime "validuntil"
    t.integer  "mpid"
  end

  add_index "lime_tokens_931453", ["token"], name: "idx_token_token_931453_12274", using: :btree

  create_table "lime_user_groups", primary_key: "ugid", force: :cascade do |t|
    t.string  "name",        limit: 20, null: false
    t.text    "description",            null: false
    t.integer "owner_id",               null: false
  end

  create_table "lime_user_in_groups", id: false, force: :cascade do |t|
    t.integer "ugid", null: false
    t.integer "uid",  null: false
  end

  create_table "lime_users", primary_key: "uid", force: :cascade do |t|
    t.string   "users_name",           limit: 64,  default: "",        null: false
    t.binary   "password",                                             null: false
    t.string   "full_name",            limit: 50,                      null: false
    t.integer  "parent_id",                                            null: false
    t.string   "lang",                 limit: 20
    t.string   "email",                limit: 254
    t.string   "htmleditormode",       limit: 7,   default: "default"
    t.string   "templateeditormode",   limit: 7,   default: "default", null: false
    t.string   "questionselectormode", limit: 7,   default: "default", null: false
    t.binary   "one_time_pw"
    t.integer  "dateformat",                       default: 1,         null: false
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "lime_users", ["users_name"], name: "lime_users_users_name_key", unique: true, using: :btree

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

  create_table "meta_attribute_entity_groups", force: :cascade do |t|
    t.text    "group_name",                                 null: false
    t.text    "parent_table",                               null: false
    t.boolean "visible",                     default: true
    t.string  "parent_table_pk", limit: 255
  end

  create_table "meta_attribute_groups", force: :cascade do |t|
    t.text    "group_name",                  null: false
    t.text    "parent_table",                null: false
    t.boolean "visible",      default: true
  end

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

  create_table "p4_clinics", force: :cascade do |t|
    t.string "p4_program_id",       null: false
    t.string "p4_clinic_id",        null: false
    t.string "clinic_abbreviation"
  end

  add_index "p4_clinics", ["p4_clinic_id"], name: "u_p4_clinic_id", unique: true, using: :btree

  create_table "p4_programs", force: :cascade do |t|
    t.string "abfm_program_id", null: false
    t.string "p4_program_id",   null: false
    t.string "program_name"
    t.string "alias"
  end

  create_table "p4_resident_clinics", id: false, force: :cascade do |t|
    t.integer "p4_resident_id", null: false
    t.string  "p4_clinic_id",   null: false
    t.integer "first_year"
    t.integer "last_year"
  end

  create_table "p4_residents", force: :cascade do |t|
    t.string  "p4_program_id"
    t.string  "abfm_last_four",     null: false
    t.string  "abfm_last_four_old"
    t.integer "entry_year",         null: false
    t.integer "graduation_year"
    t.string  "error_codes"
    t.string  "notes"
  end

  create_table "p4_residents_nonconsenting", force: :cascade do |t|
    t.string  "p4_program_id",   null: false
    t.string  "abfm_last_four",  null: false
    t.integer "graduation_year"
  end

  create_table "p4_webads_rankings", id: false, force: :cascade do |t|
    t.string  "p4_program_id",   null: false
    t.integer "ranking_type_id", null: false
    t.integer "rank",            null: false
    t.string  "name",            null: false
    t.integer "year",            null: false
  end

  create_table "permission_groups", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "survey_assignments", force: :cascade do |t|
    t.boolean  "as_inline",           default: false
    t.string   "title"
    t.integer  "lime_survey_sid",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_group_id"
  end

  add_index "survey_assignments", ["assignment_group_id"], name: "index_survey_assignments_on_assignment_group_id", using: :btree
  add_index "survey_assignments", ["lime_survey_sid"], name: "index_survey_assignments_on_lime_survey_sid", using: :btree

  create_table "user_assignments", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "survey_assignment_id", null: false
    t.integer  "lime_token_tid"
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_externals", force: :cascade do |t|
    t.integer "user_id"
    t.string  "ident",      limit: 255
    t.string  "ident_type", limit: 255
    t.boolean "use_email",              default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.text     "p4_program_id"
    t.text     "roles"
    t.string   "full_name",              limit: 255
    t.string   "username",               limit: 255
    t.datetime "locked_at"
    t.boolean  "is_ldap",                            default: false
    t.integer  "permission_group_id"
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

  create_table "y1_continuity_clinics", id: false, force: :cascade do |t|
    t.string  "p4_program_id",                                            null: false
    t.string  "settingid",                                                null: false
    t.string  "teachingsite"
    t.integer "learningsetting",       limit: 8
    t.string  "learningsettingtxt"
    t.integer "ptassigned",            limit: 8
    t.decimal "pgy1routine",                     precision: 11, scale: 2
    t.decimal "pgy2routine",                     precision: 11, scale: 2
    t.decimal "pgy3routine",                     precision: 11, scale: 2
    t.decimal "pgy4routine",                     precision: 11, scale: 2
    t.decimal "pgy1acute",                       precision: 11, scale: 2
    t.decimal "pgy2acute",                       precision: 11, scale: 2
    t.decimal "pgy3acute",                       precision: 11, scale: 2
    t.decimal "pgy4acute",                       precision: 11, scale: 2
    t.integer "daysnewapptfac",        limit: 8
    t.integer "daysnewapptres",        limit: 8
    t.integer "daysfuapptfac",         limit: 8
    t.integer "daysfuapptres",         limit: 8
    t.integer "daysacuteapptfac",      limit: 8
    t.integer "daysacuteapptres",      limit: 8
    t.integer "numexamrooms",          limit: 8
    t.integer "numptlastyrfac",        limit: 8
    t.integer "numptlastyrres",        limit: 8
    t.decimal "ftefp",                           precision: 11, scale: 2
    t.decimal "ftefmres",                        precision: 11, scale: 2
    t.decimal "fteped",                          precision: 11, scale: 2
    t.decimal "ftepedres",                       precision: 11, scale: 2
    t.decimal "fteim",                           precision: 11, scale: 2
    t.decimal "fteimres",                        precision: 11, scale: 2
    t.decimal "fteob",                           precision: 11, scale: 2
    t.decimal "fteobres",                        precision: 11, scale: 2
    t.decimal "fteotherphys1",                   precision: 11, scale: 2
    t.string  "fteotherphys1txt"
    t.decimal "fteotherphys2",                   precision: 11, scale: 2
    t.string  "fteotherphys2txt"
    t.decimal "fteotherphys3",                   precision: 11, scale: 2
    t.string  "fteotherphys3txt"
    t.decimal "ftenp",                           precision: 11, scale: 2
    t.decimal "ftepa",                           precision: 11, scale: 2
    t.decimal "fternlpn",                        precision: 11, scale: 2
    t.decimal "ftema",                           precision: 11, scale: 2
    t.decimal "fteallied",                       precision: 11, scale: 2
    t.decimal "fteadmin",                        precision: 11, scale: 2
    t.decimal "ftepsych",                        precision: 11, scale: 2
    t.decimal "ftesocial",                       precision: 11, scale: 2
    t.decimal "ftediet",                         precision: 11, scale: 2
    t.decimal "ftepteduc",                       precision: 11, scale: 2
    t.decimal "fteotherspec1",                   precision: 11, scale: 2
    t.string  "fteotherspec1txt"
    t.decimal "fteotherspec2",                   precision: 11, scale: 2
    t.string  "fteotherspec2txt"
    t.decimal "fteotherspec3",                   precision: 11, scale: 2
    t.string  "fteotherspec3txt"
    t.integer "numnp",                 limit: 8
    t.integer "numpa",                 limit: 8
    t.integer "numrnlpn",              limit: 8
    t.integer "numma",                 limit: 8
    t.integer "numallied",             limit: 8
    t.integer "numpsych",              limit: 8
    t.integer "numsocial",             limit: 8
    t.integer "numdiet",               limit: 8
    t.integer "numpteduc",             limit: 8
    t.integer "numotherspec",          limit: 8
    t.string  "numotherspectxt"
    t.integer "integrated",            limit: 8
    t.integer "statemr",               limit: 8
    t.integer "statpaperless",         limit: 8
    t.integer "statremote",            limit: 8
    t.integer "stattranscription",     limit: 8
    t.integer "statscheduling",        limit: 8
    t.integer "statbilling",           limit: 8
    t.integer "statorders",            limit: 8
    t.integer "stathospemr",           limit: 8
    t.integer "statptcommunication",   limit: 8
    t.integer "statprovcommunication", limit: 8
    t.integer "statqa",                limit: 8
    t.integer "statdisregistry",       limit: 8
    t.integer "statprevregistry",      limit: 8
    t.integer "statresearch",          limit: 8
    t.integer "statopenaccess",        limit: 8
    t.integer "statexpandedhrs",       limit: 8
    t.integer "stattelephone",         limit: 8
    t.integer "statnetscheduling",     limit: 8
    t.integer "statsurvey",            limit: 8
    t.integer "statspace",             limit: 8
    t.integer "statparking",           limit: 8
    t.integer "stattransit",           limit: 8
    t.integer "statteams",             limit: 8
    t.integer "statpsych",             limit: 8
    t.integer "statcasemgt",           limit: 8
    t.integer "statpharm",             limit: 8
    t.integer "statgroup",             limit: 8
    t.integer "statptcentered",        limit: 8
    t.string  "emrbrand"
    t.string  "emrversion"
    t.integer "emryrs",                limit: 8
    t.integer "emrmonths",             limit: 8
    t.integer "emrforclinqual",        limit: 8
    t.string  "emrforclinqualtxt"
    t.integer "emrforqualsafe",        limit: 8
    t.string  "emrforqualsafetxt"
    t.string  "noemr"
  end

  add_index "y1_continuity_clinics", ["settingid"], name: "y1_continuity_clinics_settingid_key", unique: true, using: :btree

  create_table "y1_graduate_responses", force: :cascade do |t|
    t.string  "graduateid",                                         null: false
    t.string  "p4_program_id",                                      null: false
    t.integer "q101a",           limit: 8
    t.integer "q101b",           limit: 8
    t.integer "q101c",           limit: 8
    t.integer "q101d",           limit: 8
    t.integer "q102a",           limit: 8
    t.integer "q102b",           limit: 8
    t.integer "q102c",           limit: 8
    t.integer "q102d",           limit: 8
    t.string  "q102d_other"
    t.integer "q103a",           limit: 8
    t.integer "q103b_1",         limit: 8
    t.integer "q103b_2",         limit: 8
    t.integer "q103b_3",         limit: 8
    t.integer "q103b_4",         limit: 8
    t.integer "q103b_5",         limit: 8
    t.integer "q103b_6",         limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.string  "q20.02"
    t.string  "q20.03"
    t.integer "q105",            limit: 8
    t.integer "q106",            limit: 8
    t.integer "q107_1",          limit: 8
    t.integer "q107_2",          limit: 8
    t.integer "q107_3",          limit: 8
    t.integer "q107_4",          limit: 8
    t.integer "q107_5",          limit: 8
    t.integer "q107_6",          limit: 8
    t.string  "q107_other"
    t.integer "q108",            limit: 8
    t.integer "q201",            limit: 8
    t.string  "q201_other"
    t.integer "q202_a",          limit: 8
    t.integer "q202_b",          limit: 8
    t.integer "q202_c",          limit: 8
    t.integer "q202_d",          limit: 8
    t.integer "q202_e",          limit: 8
    t.integer "q202_f",          limit: 8
    t.integer "q202_g",          limit: 8
    t.integer "q202_h",          limit: 8
    t.string  "q202_other"
    t.integer "q4301",           limit: 8
    t.integer "q203",            limit: 8
    t.decimal "q204",                      precision: 11, scale: 2
    t.decimal "q205",                      precision: 11, scale: 2
    t.decimal "q206",                      precision: 11, scale: 2
    t.decimal "q207a",                     precision: 11, scale: 2
    t.decimal "q207b",                     precision: 11, scale: 2
    t.integer "q207c",           limit: 8
    t.decimal "q207d",                     precision: 11, scale: 2
    t.decimal "q207e",                     precision: 11, scale: 2
    t.decimal "q207f",                     precision: 11, scale: 2
    t.string  "q207f_other"
    t.integer "q208",            limit: 8
    t.integer "q301a",           limit: 8
    t.integer "q301b",           limit: 8
    t.integer "q301c",           limit: 8
    t.integer "q301d",           limit: 8
    t.integer "q401",            limit: 8
    t.integer "q402",            limit: 8
    t.integer "q403",            limit: 8
    t.integer "q404",            limit: 8
    t.integer "q405",            limit: 8
    t.integer "q406",            limit: 8
    t.integer "q407",            limit: 8
    t.integer "q408",            limit: 8
    t.integer "q409",            limit: 8
    t.integer "q410",            limit: 8
    t.integer "q411",            limit: 8
    t.integer "q412",            limit: 8
    t.integer "q413",            limit: 8
    t.integer "q414",            limit: 8
    t.integer "q415",            limit: 8
    t.integer "q416",            limit: 8
    t.integer "q417",            limit: 8
    t.integer "q418",            limit: 8
    t.integer "q419",            limit: 8
    t.integer "q420",            limit: 8
    t.integer "q421",            limit: 8
    t.integer "q422",            limit: 8
    t.integer "q423",            limit: 8
    t.integer "q424",            limit: 8
    t.integer "q425",            limit: 8
    t.integer "q426",            limit: 8
    t.integer "q427",            limit: 8
    t.integer "q428",            limit: 8
    t.integer "q501a",           limit: 8
    t.integer "q501a_group",     limit: 8
    t.integer "q501b",           limit: 8
    t.integer "q501b_group",     limit: 8
    t.integer "q501c",           limit: 8
    t.integer "q501c_group",     limit: 8
    t.integer "q501d",           limit: 8
    t.integer "q501d_group",     limit: 8
    t.integer "q501e",           limit: 8
    t.integer "q501e_group",     limit: 8
    t.integer "q501f",           limit: 8
    t.integer "q501f_group",     limit: 8
    t.integer "q501g",           limit: 8
    t.integer "q501g_group",     limit: 8
    t.integer "q502",            limit: 8
    t.integer "q503",            limit: 8
    t.decimal "q503a",                     precision: 11, scale: 2
    t.integer "q503b",           limit: 8
    t.integer "q503_group",      limit: 8
    t.integer "q504",            limit: 8
    t.string  "q504_describe"
    t.integer "q114",            limit: 8
    t.integer "q505_1",          limit: 8
    t.integer "q505_2",          limit: 8
    t.integer "q505_3",          limit: 8
    t.integer "q119.01",         limit: 8
    t.integer "q119.02",         limit: 8
    t.integer "q505_4",          limit: 8
    t.string  "q505_other"
    t.integer "q506a",           limit: 8
    t.integer "q506a_practiced", limit: 8
    t.integer "q506b",           limit: 8
    t.integer "q506b_practiced", limit: 8
    t.integer "q506c",           limit: 8
    t.integer "q506c_practiced", limit: 8
    t.integer "q506d",           limit: 8
    t.integer "q506d_practiced", limit: 8
    t.integer "q506e",           limit: 8
    t.integer "q506e_practiced", limit: 8
    t.integer "q507a",           limit: 8
    t.integer "q507a_practiced", limit: 8
    t.integer "q507b",           limit: 8
    t.integer "q507b_practiced", limit: 8
    t.integer "q507c",           limit: 8
    t.integer "q507c_practiced", limit: 8
    t.integer "q507d",           limit: 8
    t.integer "q507d_practiced", limit: 8
    t.integer "q507e",           limit: 8
    t.integer "q507e_practiced", limit: 8
    t.integer "q507f",           limit: 8
    t.integer "q507f_practiced", limit: 8
    t.integer "q507g",           limit: 8
    t.integer "q507g_practiced", limit: 8
    t.integer "q507h",           limit: 8
    t.integer "q507h_practiced", limit: 8
    t.integer "q507i",           limit: 8
    t.integer "q507i_practiced", limit: 8
    t.integer "q507j",           limit: 8
    t.integer "q507j_practiced", limit: 8
    t.integer "q508a",           limit: 8
    t.integer "q508a_practiced", limit: 8
    t.integer "q508b",           limit: 8
    t.integer "q508b_practiced", limit: 8
    t.integer "q508c",           limit: 8
    t.integer "q508c_practiced", limit: 8
    t.integer "q508d",           limit: 8
    t.integer "q508d_practiced", limit: 8
    t.integer "q508e",           limit: 8
    t.integer "q508e_practiced", limit: 8
    t.integer "q508f",           limit: 8
    t.integer "q508f_practiced", limit: 8
    t.integer "q508g",           limit: 8
    t.integer "q508g_practiced", limit: 8
    t.integer "q509a",           limit: 8
    t.integer "q509a_practiced", limit: 8
    t.integer "q509b",           limit: 8
    t.integer "q509b_practiced", limit: 8
    t.integer "q509c",           limit: 8
    t.integer "q509c_practiced", limit: 8
    t.integer "q510a",           limit: 8
    t.integer "q510a_practiced", limit: 8
    t.integer "q510b",           limit: 8
    t.integer "q510b_practiced", limit: 8
    t.integer "q510c",           limit: 8
    t.integer "q510c_practiced", limit: 8
    t.integer "q510d",           limit: 8
    t.integer "q510d_practiced", limit: 8
    t.integer "q510e",           limit: 8
    t.integer "q510e_practiced", limit: 8
    t.integer "q510f",           limit: 8
    t.integer "q510f_practiced", limit: 8
    t.integer "q510g",           limit: 8
    t.integer "q510g_practiced", limit: 8
    t.integer "q510h",           limit: 8
    t.integer "q510h_practiced", limit: 8
    t.integer "q511a",           limit: 8
    t.integer "q511a_practiced", limit: 8
    t.integer "q511b",           limit: 8
    t.integer "q511b_practiced", limit: 8
    t.integer "q511c",           limit: 8
    t.integer "q511c_practiced", limit: 8
    t.integer "q512a",           limit: 8
    t.integer "q512a_practiced", limit: 8
    t.integer "q512b",           limit: 8
    t.integer "q512b_practiced", limit: 8
    t.integer "q513a",           limit: 8
    t.integer "q513a_practiced", limit: 8
    t.integer "q513b",           limit: 8
    t.integer "q513b_practiced", limit: 8
    t.integer "q513c",           limit: 8
    t.integer "q513c_practiced", limit: 8
    t.integer "q513d",           limit: 8
    t.integer "q513d_practiced", limit: 8
    t.integer "q513e",           limit: 8
    t.integer "q513e_practiced", limit: 8
    t.integer "q514a",           limit: 8
    t.integer "q514a_practiced", limit: 8
    t.integer "q514b",           limit: 8
    t.integer "q514b_practiced", limit: 8
    t.integer "q514c",           limit: 8
    t.integer "q514c_practiced", limit: 8
    t.integer "q514d",           limit: 8
    t.integer "q514d_practiced", limit: 8
    t.integer "q514e",           limit: 8
    t.integer "q514e_practiced", limit: 8
    t.integer "q514f",           limit: 8
    t.integer "q514f_practiced", limit: 8
    t.integer "q514g",           limit: 8
    t.integer "q514g_practiced", limit: 8
    t.integer "q514h",           limit: 8
    t.integer "q514h_practiced", limit: 8
    t.integer "q601a",           limit: 8
    t.integer "q601b",           limit: 8
    t.integer "q601c",           limit: 8
    t.integer "q601d",           limit: 8
    t.integer "q601e",           limit: 8
    t.integer "q602a",           limit: 8
    t.integer "q602b",           limit: 8
    t.integer "q602c",           limit: 8
    t.integer "q602d",           limit: 8
    t.integer "q602e",           limit: 8
    t.integer "q603a",           limit: 8
    t.integer "q603b",           limit: 8
    t.integer "q603c",           limit: 8
    t.integer "q603d",           limit: 8
    t.integer "q603e",           limit: 8
    t.integer "q603f",           limit: 8
    t.integer "q604a",           limit: 8
    t.integer "q604b",           limit: 8
    t.integer "q604c",           limit: 8
    t.integer "q604d",           limit: 8
    t.integer "q605a",           limit: 8
    t.integer "q605b",           limit: 8
    t.integer "q605c",           limit: 8
    t.integer "q605d",           limit: 8
    t.integer "q606a",           limit: 8
    t.integer "q606b",           limit: 8
    t.integer "q606c",           limit: 8
    t.integer "q606d",           limit: 8
    t.integer "q606e",           limit: 8
    t.integer "q606f",           limit: 8
    t.integer "q606g",           limit: 8
    t.integer "q606h",           limit: 8
    t.integer "q606i",           limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y1_residency_programs", primary_key: "p4_program_id", force: :cascade do |t|
    t.integer "id",                          limit: 8,                          null: false
    t.integer "numinterviewed",              limit: 8
    t.integer "numfilledmatchusallo",        limit: 8
    t.integer "numfilledmatchusosteo",       limit: 8
    t.integer "numfilledmatchintl",          limit: 8
    t.integer "numfilledjulyusallo",         limit: 8
    t.integer "numfilledjulyusosteo",        limit: 8
    t.integer "numfilledjulyintl",           limit: 8
    t.integer "resleave",                    limit: 8
    t.integer "resleavepgy1",                limit: 8
    t.integer "resleavepgy2",                limit: 8
    t.integer "resleavepgy3",                limit: 8
    t.integer "resleavepgy4",                limit: 8
    t.integer "pctaafp",                     limit: 8
    t.integer "numqipgy1avail",              limit: 8
    t.integer "numqipgy1res",                limit: 8
    t.integer "numqipgy2avail",              limit: 8
    t.integer "numqipgy2res",                limit: 8
    t.integer "numqipgy3avail",              limit: 8
    t.integer "numqipgy3res",                limit: 8
    t.integer "numqipgy4avail",              limit: 8
    t.integer "numqipgy4res",                limit: 8
    t.integer "numrschpgy1avail",            limit: 8
    t.integer "numrschpgy1res",              limit: 8
    t.integer "numrschpgy2avail",            limit: 8
    t.integer "numrschpgy2res",              limit: 8
    t.integer "numrschpgy3avail",            limit: 8
    t.integer "numrschpgy3res",              limit: 8
    t.integer "numrschpgy4avail",            limit: 8
    t.integer "numrschpgy4res",              limit: 8
    t.decimal "pctpeerreview",                         precision: 11, scale: 2
    t.decimal "pctnonpeerreview",                      precision: 11, scale: 2
    t.decimal "pctpresenting",                         precision: 11, scale: 2
    t.decimal "revgrants",                             precision: 11, scale: 2
    t.decimal "revcharity",                            precision: 11, scale: 2
    t.decimal "revstate",                              precision: 11, scale: 2
    t.decimal "revmedicaredirect",                     precision: 11, scale: 2
    t.decimal "revmedicareindirect",                   precision: 11, scale: 2
    t.decimal "revmedicarehmo",                        precision: 11, scale: 2
    t.decimal "revmedicaredisproportionate",           precision: 11, scale: 2
    t.decimal "revmedicaiddirect",                     precision: 11, scale: 2
    t.decimal "revmedicaidindirect",                   precision: 11, scale: 2
    t.decimal "revhospitalgme",                        precision: 11, scale: 2
    t.decimal "revother",                              precision: 11, scale: 2
    t.string  "revothertxt"
    t.decimal "revtotal",                              precision: 11, scale: 2
    t.decimal "expfacultyfte",                         precision: 11, scale: 2
    t.decimal "expfacultysalary",                      precision: 11, scale: 2
    t.decimal "expstafffte",                           precision: 11, scale: 2
    t.decimal "expstaffsalary",                        precision: 11, scale: 2
    t.decimal "expbenefits",                           precision: 11, scale: 2
    t.decimal "expcontracts",                          precision: 11, scale: 2
    t.decimal "expequipment",                          precision: 11, scale: 2
    t.decimal "expsupplies",                           precision: 11, scale: 2
    t.decimal "exprent",                               precision: 11, scale: 2
    t.decimal "expotherresop",                         precision: 11, scale: 2
    t.string  "expotherresoptxt"
    t.decimal "exprecruitment",                        precision: 11, scale: 2
    t.decimal "exphospitalgme",                        precision: 11, scale: 2
    t.decimal "expmalpractice",                        precision: 11, scale: 2
    t.decimal "exphospstepdown",                       precision: 11, scale: 2
    t.decimal "expmedschool",                          precision: 11, scale: 2
    t.decimal "expdme",                                precision: 11, scale: 2
    t.decimal "expdfm",                                precision: 11, scale: 2
    t.decimal "expother",                              precision: 11, scale: 2
    t.string  "expothertxt"
    t.decimal "exptotal",                              precision: 11, scale: 2
    t.integer "ratefacdevel",                limit: 8
    t.integer "ratefacmorale",               limit: 8
    t.integer "rateresmorale",               limit: 8
    t.integer "ratesatisfaction",            limit: 8
    t.decimal "facsalaryexp",                          precision: 11, scale: 2
    t.decimal "volfacultyexp",                         precision: 11, scale: 2
    t.decimal "clinstaffexp",                          precision: 11, scale: 2
    t.decimal "nonclinstaffexp",                       precision: 11, scale: 2
    t.decimal "recruitexp",                            precision: 11, scale: 2
    t.decimal "contractexp",                           precision: 11, scale: 2
    t.decimal "capitalexp",                            precision: 11, scale: 2
    t.decimal "billingisexp",                          precision: 11, scale: 2
    t.decimal "grantsrev",                             precision: 11, scale: 2
    t.decimal "charitablerev",                         precision: 11, scale: 2
    t.decimal "ptcarerev",                             precision: 11, scale: 2
    t.decimal "techancrev",                            precision: 11, scale: 2
  end

  add_index "y1_residency_programs", ["id"], name: "y1_residency_programs_id_key", unique: true, using: :btree

  create_table "y1_resident_responses", force: :cascade do |t|
    t.string  "p4residency_abfm_id",                null: false
    t.string  "p4_program_id",                      null: false
    t.integer "abfm_last_four",           limit: 8
    t.integer "abfm_last_four2",          limit: 8
    t.string  "p4resid"
    t.string  "contclin"
    t.integer "age",                      limit: 8
    t.integer "gender",                   limit: 8
    t.integer "race_c",                   limit: 8
    t.integer "race_aa",                  limit: 8
    t.integer "race_ap",                  limit: 8
    t.integer "race_in",                  limit: 8
    t.integer "race_o",                   limit: 8
    t.integer "ethnicity",                limit: 8
    t.integer "marital",                  limit: 8
    t.integer "children",                 limit: 8
    t.integer "many",                     limit: 8
    t.integer "medicalafterbs",           limit: 8
    t.integer "yearsbeforemedschool",     limit: 8
    t.integer "usamedschool",             limit: 8
    t.integer "firstgenerationcollege",   limit: 8
    t.integer "firstgenphysician",        limit: 8
    t.integer "firstfamilyphysician",     limit: 8
    t.string  "medgraddate"
    t.integer "programyear",              limit: 8
    t.integer "influence",                limit: 8
    t.integer "masters",                  limit: 8
    t.integer "goals",                    limit: 8
    t.integer "activitiesclinrot",        limit: 8
    t.integer "activitieslectsem",        limit: 8
    t.integer "activitiesservlearn",      limit: 8
    t.integer "facultyteaching",          limit: 8
    t.integer "facultysupervising",       limit: 8
    t.integer "participationjournalclub", limit: 8
    t.integer "participationconferences", limit: 8
    t.integer "feedback",                 limit: 8
    t.integer "evaluatefaculty",          limit: 8
    t.integer "evaluateprogram",          limit: 8
    t.integer "speakfreely",              limit: 8
    t.integer "othertraineesinterfere",   limit: 8
    t.integer "strengthsfacteaching",     limit: 8
    t.integer "strengthsoverallcurr",     limit: 8
    t.integer "strengthscurrchange",      limit: 8
    t.integer "strengthspracchange",      limit: 8
    t.integer "strengthscompetence",      limit: 8
    t.integer "strengthsp4innovations",   limit: 8
    t.integer "strengthsp4implement",     limit: 8
    t.integer "satisfied",                limit: 8
    t.integer "importance1",              limit: 8
    t.integer "importance2",              limit: 8
    t.integer "importance3",              limit: 8
    t.integer "importance4",              limit: 8
    t.integer "importance5",              limit: 8
    t.integer "importance6",              limit: 8
    t.integer "importance7",              limit: 8
    t.integer "importance8",              limit: 8
    t.integer "importance9",              limit: 8
    t.integer "importance10",             limit: 8
    t.integer "importance11",             limit: 8
    t.integer "importance12",             limit: 8
    t.integer "importance13",             limit: 8
    t.integer "importance14",             limit: 8
    t.integer "importance15",             limit: 8
    t.integer "importance16",             limit: 8
    t.integer "importance17",             limit: 8
    t.integer "importance18",             limit: 8
    t.integer "importance19",             limit: 8
    t.integer "importance20",             limit: 8
    t.integer "importance21",             limit: 8
    t.integer "importance22",             limit: 8
    t.integer "importance23",             limit: 8
    t.integer "importance24",             limit: 8
    t.integer "importance25",             limit: 8
    t.integer "importance26",             limit: 8
    t.integer "importance27",             limit: 8
    t.integer "p4_resident_id"
  end

  create_table "y1_webads_responses", primary_key: "p4_program_id", force: :cascade do |t|
    t.integer "pgy1activefulltime", limit: 8
    t.integer "pgy1activeparttime", limit: 8
    t.integer "pgy1completed",      limit: 8
    t.integer "pgy2activefulltime", limit: 8
    t.integer "pgy2activeparttime", limit: 8
    t.integer "pgy2completed",      limit: 8
    t.integer "pgy3activefulltime", limit: 8
    t.integer "pgy3activeparttime", limit: 8
    t.integer "pgy3completed",      limit: 8
    t.integer "pgy4activefulltime", limit: 8
    t.integer "pgy4activeparttime", limit: 8
    t.integer "pgy4completed",      limit: 8
    t.decimal "dailyptsadultyr1"
    t.decimal "dailyptsadultyr2"
    t.decimal "dailyptsadultyr3"
    t.decimal "dailyptsnewbornyr1"
    t.decimal "dailyptsnewbornyr2"
    t.decimal "dailyptsnewbornyr3"
    t.decimal "dailyptspedsyr1"
    t.decimal "dailyptspedsyr2"
    t.decimal "dailyptspedsyr3"
    t.integer "nstcst",             limit: 8
    t.integer "injectionasp",       limit: 8
    t.integer "omt",                limit: 8
    t.integer "castremoval",        limit: 8
    t.integer "circumcision",       limit: 8
    t.integer "treadmill",          limit: 8
    t.integer "ekg",                limit: 8
    t.integer "spirometry",         limit: 8
    t.integer "intubation",         limit: 8
    t.integer "vasectomy",          limit: 8
    t.integer "skinbiopsy",         limit: 8
    t.integer "cryosurgery",        limit: 8
    t.integer "skiniandd",          limit: 8
    t.integer "ingrowntoenail",     limit: 8
    t.integer "lacrepair",          limit: 8
    t.integer "papsmear",           limit: 8
    t.integer "bartholin",          limit: 8
    t.integer "iud",                limit: 8
    t.integer "endometrialbx",      limit: 8
    t.integer "curettage",          limit: 8
    t.integer "colposcopy",         limit: 8
    t.integer "obultrasound",       limit: 8
    t.integer "genitalwarts",       limit: 8
    t.integer "catheter",           limit: 8
    t.integer "cerumenremoval",     limit: 8
    t.integer "eyefb",              limit: 8
    t.integer "ivstart",            limit: 8
  end

  create_table "y2_continuity_clinics", id: false, force: :cascade do |t|
    t.string  "p4_program_id",                                            null: false
    t.string  "settingid",                                                null: false
    t.integer "pgy1",                  limit: 8
    t.integer "pgy2",                  limit: 8
    t.integer "pgy3",                  limit: 8
    t.integer "pgy4",                  limit: 8
    t.integer "totpgy",                limit: 8
    t.integer "ptassigned",            limit: 8
    t.decimal "pgy1routine",                     precision: 11, scale: 2
    t.decimal "pgy2routine",                     precision: 11, scale: 2
    t.decimal "pgy3routine",                     precision: 11, scale: 2
    t.decimal "pgy4routine",                     precision: 11, scale: 2
    t.decimal "pgy1acute",                       precision: 11, scale: 2
    t.decimal "pgy2acute",                       precision: 11, scale: 2
    t.decimal "pgy3acute",                       precision: 11, scale: 2
    t.decimal "pgy4acute",                       precision: 11, scale: 2
    t.decimal "daysnewapptfac",                  precision: 11, scale: 2
    t.decimal "daysnewapptfac3",                 precision: 11, scale: 2
    t.decimal "daysnewapptres",                  precision: 11, scale: 2
    t.decimal "daysnewapptres3",                 precision: 11, scale: 2
    t.decimal "daysfuapptfac",                   precision: 11, scale: 2
    t.decimal "daysfuapptfac3",                  precision: 11, scale: 2
    t.decimal "daysfuapptres",                   precision: 11, scale: 2
    t.decimal "daysfuapptres3",                  precision: 11, scale: 2
    t.decimal "daysacuteapptfac",                precision: 11, scale: 2
    t.decimal "daysacuteapptfac3",               precision: 11, scale: 2
    t.decimal "daysacuteapptres",                precision: 11, scale: 2
    t.decimal "daysacuteapptres3",               precision: 11, scale: 2
    t.integer "numexamrooms",          limit: 8
    t.decimal "numptfac",                        precision: 11, scale: 2
    t.decimal "numptmid",                        precision: 11, scale: 2
    t.decimal "numptres",                        precision: 11, scale: 2
    t.decimal "ftefp",                           precision: 11, scale: 2
    t.decimal "ftefmres",                        precision: 11, scale: 2
    t.decimal "fteped",                          precision: 11, scale: 2
    t.decimal "ftepedres",                       precision: 11, scale: 2
    t.decimal "fteim",                           precision: 11, scale: 2
    t.decimal "fteimres",                        precision: 11, scale: 2
    t.decimal "fteob",                           precision: 11, scale: 2
    t.decimal "fteobres",                        precision: 11, scale: 2
    t.decimal "fteotherphys1",                   precision: 11, scale: 2
    t.string  "fteotherphys1txt"
    t.decimal "fteotherphys2",                   precision: 11, scale: 2
    t.string  "fteotherphys2txt"
    t.decimal "ftenp",                           precision: 11, scale: 2
    t.decimal "ftepa",                           precision: 11, scale: 2
    t.decimal "fternlpn",                        precision: 11, scale: 2
    t.decimal "ftema",                           precision: 11, scale: 2
    t.decimal "fteallied",                       precision: 11, scale: 2
    t.decimal "fteadmin",                        precision: 11, scale: 2
    t.decimal "ftepsych",                        precision: 11, scale: 2
    t.decimal "ftesocial",                       precision: 11, scale: 2
    t.decimal "ftediet",                         precision: 11, scale: 2
    t.decimal "ftepteduc",                       precision: 11, scale: 2
    t.decimal "fteotherspec1",                   precision: 11, scale: 2
    t.string  "fteotherspec1txt"
    t.decimal "fteotherspec2",                   precision: 11, scale: 2
    t.string  "fteotherspec2txt"
    t.integer "numnp",                 limit: 8
    t.integer "numpa",                 limit: 8
    t.integer "numrnlpn",              limit: 8
    t.integer "numma",                 limit: 8
    t.integer "numallied",             limit: 8
    t.integer "numpsych",              limit: 8
    t.integer "numsocial",             limit: 8
    t.integer "numdiet",               limit: 8
    t.integer "numpteduc",             limit: 8
    t.integer "numotherspec",          limit: 8
    t.string  "numotherspectxt"
    t.integer "integrated",            limit: 8
    t.decimal "owner",                           precision: 11, scale: 2
    t.string  "ownerother"
    t.decimal "male",                            precision: 11, scale: 2
    t.decimal "female",                          precision: 11, scale: 2
    t.string  "gendersource"
    t.decimal "lt3",                             precision: 11, scale: 2
    t.decimal "three",                           precision: 11, scale: 2
    t.decimal "eighteen",                        precision: 11, scale: 2
    t.decimal "twentyfive",                      precision: 11, scale: 2
    t.decimal "fortyfive",                       precision: 11, scale: 2
    t.decimal "sixtyfive",                       precision: 11, scale: 2
    t.decimal "seventyfive",                     precision: 11, scale: 2
    t.string  "agesource"
    t.decimal "hispanic",                        precision: 11, scale: 2
    t.decimal "nonhispanic",                     precision: 11, scale: 2
    t.decimal "indian",                          precision: 11, scale: 2
    t.decimal "asian",                           precision: 11, scale: 2
    t.decimal "black",                           precision: 11, scale: 2
    t.decimal "hawaiian",                        precision: 11, scale: 2
    t.decimal "white",                           precision: 11, scale: 2
    t.decimal "otherrace",                       precision: 11, scale: 2
    t.string  "racesource"
    t.decimal "prepaid",                         precision: 11, scale: 2
    t.decimal "ffs",                             precision: 11, scale: 2
    t.decimal "medicare",                        precision: 11, scale: 2
    t.decimal "medicaid",                        precision: 11, scale: 2
    t.decimal "otherpay",                        precision: 11, scale: 2
    t.decimal "uninsured",                       precision: 11, scale: 2
    t.string  "paysource"
    t.integer "xrays",                 limit: 8
    t.integer "statemr",               limit: 8
    t.integer "statpaperless",         limit: 8
    t.integer "statremote",            limit: 8
    t.integer "stattranscription",     limit: 8
    t.integer "statscheduling",        limit: 8
    t.integer "statbilling",           limit: 8
    t.integer "statorders",            limit: 8
    t.integer "stathospemr",           limit: 8
    t.integer "statptcommunication",   limit: 8
    t.integer "statprovcommunication", limit: 8
    t.integer "statqa",                limit: 8
    t.integer "statdisregistry",       limit: 8
    t.integer "statprevregistry",      limit: 8
    t.integer "statresearch",          limit: 8
    t.integer "statopenaccess",        limit: 8
    t.integer "statexpandedhrs",       limit: 8
    t.integer "stattelephone",         limit: 8
    t.integer "statnetscheduling",     limit: 8
    t.integer "statsurvey",            limit: 8
    t.integer "statspace",             limit: 8
    t.integer "statparking",           limit: 8
    t.integer "stattransit",           limit: 8
    t.integer "statteams",             limit: 8
    t.integer "statpsych",             limit: 8
    t.integer "statcasemgt",           limit: 8
    t.integer "statpharm",             limit: 8
    t.integer "statgroup",             limit: 8
    t.integer "statptcentered",        limit: 8
    t.decimal "emryrs",                          precision: 11, scale: 2
    t.string  "noemrtxt"
    t.integer "emrforsafety",          limit: 8
    t.string  "emrforsafetytxt"
  end

  add_index "y2_continuity_clinics", ["settingid"], name: "y2_continuity_clinics_settingid_key", unique: true, using: :btree

  create_table "y2_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y2_residency_programs", primary_key: "p4_program_id", force: :cascade do |t|
    t.string  "abfmresidencyid",                                      null: false
    t.integer "resleave",          limit: 8
    t.integer "resleavepgy1",      limit: 8
    t.integer "resleavepgy2",      limit: 8
    t.integer "resleavepgy3",      limit: 8
    t.integer "resleavepgy4",      limit: 8
    t.integer "facleave",          limit: 8
    t.string  "progdir"
    t.string  "siteeval"
    t.string  "assocprogdir"
    t.string  "rescoord"
    t.integer "otherfacleave1",    limit: 8
    t.string  "otherfacleave1txt"
    t.integer "otherfacleave2",    limit: 8
    t.string  "otherfacleave2txt"
    t.integer "numqipgy1res",      limit: 8
    t.integer "numqipgy2res",      limit: 8
    t.integer "numqipgy3res",      limit: 8
    t.integer "numqipgy4res",      limit: 8
    t.integer "numrschpgy1res",    limit: 8
    t.integer "numrschpgy2res",    limit: 8
    t.integer "numrschpgy3res",    limit: 8
    t.integer "numrschpgy4res",    limit: 8
    t.decimal "pctpeerreview",               precision: 11, scale: 2
    t.decimal "pctnonpeerreview",            precision: 11, scale: 2
    t.decimal "pctpresenting",               precision: 11, scale: 2
    t.integer "rps",               limit: 8
    t.integer "ratefacdevel",      limit: 8
    t.integer "ratefacmorale",     limit: 8
    t.integer "rateresmorale",     limit: 8
    t.integer "ratesatisfaction",  limit: 8
    t.decimal "facsalaryexp",                precision: 11, scale: 2
    t.decimal "volfacultyexp",               precision: 11, scale: 2
    t.decimal "clinstaffexp",                precision: 11, scale: 2
    t.decimal "nonclinstaffexp",             precision: 11, scale: 2
    t.decimal "recruitexp",                  precision: 11, scale: 2
    t.decimal "contractexp",                 precision: 11, scale: 2
    t.decimal "capitalexp",                  precision: 11, scale: 2
    t.decimal "billingisexp",                precision: 11, scale: 2
    t.decimal "grantsrev",                   precision: 11, scale: 2
    t.decimal "charitablerev",               precision: 11, scale: 2
    t.decimal "ptcarerev",                   precision: 11, scale: 2
    t.decimal "techancrev",                  precision: 11, scale: 2
  end

  create_table "y2_resident_responses", force: :cascade do |t|
    t.string  "p4residency_abfm_id",                null: false
    t.string  "p4_program_id",                      null: false
    t.integer "abfm_last_four",           limit: 8
    t.string  "p4resid"
    t.string  "contclin"
    t.integer "age",                      limit: 8
    t.integer "gender",                   limit: 8
    t.integer "race_c",                   limit: 8
    t.integer "race_aa",                  limit: 8
    t.integer "race_ap",                  limit: 8
    t.integer "race_in",                  limit: 8
    t.integer "race_o",                   limit: 8
    t.string  "raceothertxt"
    t.integer "ethnicity",                limit: 8
    t.integer "marital",                  limit: 8
    t.integer "children",                 limit: 8
    t.integer "many",                     limit: 8
    t.integer "medicalafterbs",           limit: 8
    t.integer "yearsbeforemedschool",     limit: 8
    t.string  "describebeforemed"
    t.integer "usamedschool",             limit: 8
    t.integer "firstgenerationcollege",   limit: 8
    t.integer "firstgenphysician",        limit: 8
    t.integer "firstfamilyphysician",     limit: 8
    t.string  "medgraddate"
    t.integer "programyear",              limit: 8
    t.string  "otherprogramyear"
    t.integer "influence",                limit: 8
    t.integer "masters",                  limit: 8
    t.string  "mastersdegree"
    t.string  "mastersdegreeother"
    t.integer "goals",                    limit: 8
    t.integer "facultyteaching",          limit: 8
    t.integer "facultysupervising",       limit: 8
    t.integer "participationjournalclub", limit: 8
    t.integer "participationconferences", limit: 8
    t.integer "feedback",                 limit: 8
    t.integer "evaluatefaculty",          limit: 8
    t.integer "evaluateprogram",          limit: 8
    t.integer "speakfreely",              limit: 8
    t.integer "othertraineesinterfere",   limit: 8
    t.integer "satisfied",                limit: 8
    t.integer "strengthsfacteaching",     limit: 8
    t.integer "strengthsoverallcurr",     limit: 8
    t.integer "strengthscurrchange",      limit: 8
    t.integer "strengthspracchange",      limit: 8
    t.integer "strengthscompetence",      limit: 8
    t.integer "strengthsp4innovations",   limit: 8
    t.integer "strengthsp4implement",     limit: 8
    t.integer "importance1",              limit: 8
    t.integer "importance2",              limit: 8
    t.integer "importance3",              limit: 8
    t.integer "importance4",              limit: 8
    t.integer "importance5",              limit: 8
    t.integer "importance6",              limit: 8
    t.integer "importance7",              limit: 8
    t.integer "importance8",              limit: 8
    t.integer "importance9",              limit: 8
    t.integer "importance10",             limit: 8
    t.integer "importance11",             limit: 8
    t.integer "importance12",             limit: 8
    t.integer "importance13",             limit: 8
    t.integer "importance14",             limit: 8
    t.integer "importance15",             limit: 8
    t.integer "importance16",             limit: 8
    t.integer "importance17",             limit: 8
    t.integer "importance18",             limit: 8
    t.integer "importance19",             limit: 8
    t.integer "importance20",             limit: 8
    t.integer "importance21",             limit: 8
    t.integer "importance22",             limit: 8
    t.integer "importance23",             limit: 8
    t.integer "importance24",             limit: 8
    t.integer "importance25",             limit: 8
    t.integer "importance26",             limit: 8
    t.integer "importance27",             limit: 8
    t.integer "p4_resident_id"
  end

  create_table "y2_webads_responses", primary_key: "p4_program_id", force: :cascade do |t|
    t.string  "abfmresidencyid",              null: false
    t.string  "id",                           null: false
    t.integer "pgy1activefulltime", limit: 8
    t.integer "pgy1activeparttime", limit: 8
    t.integer "pgy1completed",      limit: 8
    t.integer "pgy2activefulltime", limit: 8
    t.integer "pgy2activeparttime", limit: 8
    t.integer "pgy2completed",      limit: 8
    t.integer "pgy3activefulltime", limit: 8
    t.integer "pgy3activeparttime", limit: 8
    t.integer "pgy3completed",      limit: 8
    t.integer "pgy4activefulltime", limit: 8
    t.integer "pgy4activeparttime", limit: 8
    t.integer "pgy4completed",      limit: 8
    t.decimal "dailyptsadultyr1"
    t.decimal "dailyptsadultyr2"
    t.decimal "dailyptsadultyr3"
    t.decimal "dailyptsnewbornyr1"
    t.decimal "dailyptsnewbornyr2"
    t.decimal "dailyptsnewbornyr3"
    t.decimal "dailyptspedsyr1"
    t.decimal "dailyptspedsyr2"
    t.decimal "dailyptspedsyr3"
  end

  create_table "y3_continuity_clinics", id: false, force: :cascade do |t|
    t.string  "p4_program_id",                       null: false
    t.string  "settingid",                           null: false
    t.integer "id",                        limit: 8, null: false
    t.integer "participant_id",            limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "pgy1",                      limit: 8
    t.integer "pgy2",                      limit: 8
    t.integer "pgy3",                      limit: 8
    t.integer "pgy4",                      limit: 8
    t.integer "nopgy4",                    limit: 8
    t.integer "ptassigned",                limit: 8
    t.decimal "pgy1routine"
    t.decimal "pgy2routine"
    t.decimal "pgy3routine"
    t.decimal "pgy4routine"
    t.decimal "pgy1acute"
    t.decimal "pgy2acute"
    t.decimal "pgy3acute"
    t.decimal "pgy4acute"
    t.decimal "daysnewapptfac3"
    t.integer "daysnewapptfac3_unknown",   limit: 8
    t.decimal "daysnewapptres3"
    t.integer "daysnewapptres3_unknown",   limit: 8
    t.decimal "daysfuapptfac3"
    t.integer "daysfuapptfac3_unknown",    limit: 8
    t.decimal "daysfuapptres3"
    t.integer "daysfuapptres3_unknown",    limit: 8
    t.decimal "daysacuteapptfac3"
    t.integer "daysacuteapptfac3_unknown", limit: 8
    t.decimal "daysacuteapptres3"
    t.integer "daysacuteapptres3_unknown", limit: 8
    t.integer "numexamrooms",              limit: 8
    t.integer "numptfac",                  limit: 8
    t.integer "numptmid",                  limit: 8
    t.integer "numptres",                  limit: 8
    t.decimal "ftefp"
    t.decimal "ftefmres"
    t.decimal "fteped"
    t.decimal "ftepedres"
    t.decimal "fteim"
    t.decimal "fteimres"
    t.decimal "fteob"
    t.decimal "fteobres"
    t.integer "fteotherphys1_present",     limit: 8
    t.decimal "fteotherphys1"
    t.text    "fteotherphys1txt"
    t.integer "fteotherphys2_present",     limit: 8
    t.decimal "fteotherphys2"
    t.text    "fteotherphys2txt"
    t.decimal "ftenp"
    t.decimal "ftepa"
    t.decimal "fternlpn"
    t.decimal "ftema"
    t.decimal "fteallied"
    t.decimal "fteadmin"
    t.decimal "ftepsych"
    t.decimal "ftesocial"
    t.decimal "ftediet"
    t.decimal "ftepteduc"
    t.decimal "ftepharm"
    t.integer "fteotherspec1_present",     limit: 8
    t.decimal "fteotherspec1"
    t.text    "fteotherspec1txt"
    t.integer "fteotherspec2_present",     limit: 8
    t.decimal "fteotherspec2"
    t.text    "fteotherspec2txt"
    t.integer "numnp",                     limit: 8
    t.integer "numpa",                     limit: 8
    t.integer "numrnlpn",                  limit: 8
    t.integer "numma",                     limit: 8
    t.integer "numallied",                 limit: 8
    t.integer "numpsych",                  limit: 8
    t.integer "numsocial",                 limit: 8
    t.integer "numdiet",                   limit: 8
    t.integer "numpteduc",                 limit: 8
    t.decimal "numotherspec_present"
    t.integer "numotherspec",              limit: 8
    t.text    "numotherspectxt"
    t.integer "integrated",                limit: 8
    t.integer "owner",                     limit: 8
    t.text    "ownerother"
    t.decimal "male"
    t.decimal "female"
    t.text    "gendersource"
    t.decimal "lt3"
    t.decimal "three"
    t.decimal "eighteen"
    t.decimal "twentyfive"
    t.decimal "fortyfive"
    t.decimal "sixtyfive"
    t.decimal "seventyfive"
    t.text    "agesource"
    t.decimal "hispanic"
    t.decimal "nonhispanic"
    t.text    "ethnicitysource"
    t.decimal "indian"
    t.decimal "asian"
    t.decimal "black"
    t.decimal "hawaiian"
    t.decimal "white"
    t.integer "otherrace_present",         limit: 8
    t.decimal "otherrace"
    t.text    "otherracetxt"
    t.text    "racesource"
    t.decimal "prepaid"
    t.decimal "ffs"
    t.decimal "medicare"
    t.decimal "medicaid"
    t.integer "otherpay_present",          limit: 8
    t.decimal "otherpay"
    t.text    "otherpaytxt"
    t.decimal "uninsured"
    t.text    "paysource"
    t.integer "xrays",                     limit: 8
    t.integer "statemr",                   limit: 8
    t.integer "statpaperless",             limit: 8
    t.integer "statremote",                limit: 8
    t.integer "stattranscription",         limit: 8
    t.integer "statscheduling",            limit: 8
    t.integer "statbilling",               limit: 8
    t.integer "statorders",                limit: 8
    t.integer "stathospemr",               limit: 8
    t.integer "statptcommunication",       limit: 8
    t.integer "statprovcommunication",     limit: 8
    t.integer "statqa",                    limit: 8
    t.integer "statdisregistry",           limit: 8
    t.integer "statprevregistry",          limit: 8
    t.integer "statresearch",              limit: 8
    t.integer "statopenaccess",            limit: 8
    t.integer "statexpandedhrs",           limit: 8
    t.integer "stattelephone",             limit: 8
    t.integer "statnetscheduling",         limit: 8
    t.integer "statsurvey",                limit: 8
    t.integer "statspace",                 limit: 8
    t.integer "statparking",               limit: 8
    t.integer "stattransit",               limit: 8
    t.integer "statteams",                 limit: 8
    t.integer "statpsych",                 limit: 8
    t.integer "statcasemgt",               limit: 8
    t.integer "statpharm",                 limit: 8
    t.integer "statgroup",                 limit: 8
    t.integer "statptcentered",            limit: 8
    t.integer "emrimplemented",            limit: 8
    t.decimal "emryears"
    t.text    "emrexplain"
    t.integer "emrptsafety",               limit: 8
    t.text    "emrptsafetytxt"
  end

  add_index "y3_continuity_clinics", ["settingid"], name: "y3_continuity_clinics_settingid_key", unique: true, using: :btree

  create_table "y3_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y3_residency_programs", primary_key: "p4_program_id", force: :cascade do |t|
    t.integer "id",                   limit: 8, null: false
    t.integer "participant_id",       limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "resleave",             limit: 8
    t.integer "resleavepgy1",         limit: 8
    t.integer "resleavepgy2",         limit: 8
    t.integer "resleavepgy3",         limit: 8
    t.integer "resleavepgy4",         limit: 8
    t.integer "facleave",             limit: 8
    t.integer "progdir_leave",        limit: 8
    t.text    "progdir"
    t.integer "siteeval_leave",       limit: 8
    t.text    "siteeval"
    t.integer "assocprogdir_leave",   limit: 8
    t.text    "assocprogdir"
    t.integer "rescoord_leave",       limit: 8
    t.text    "rescoord"
    t.integer "otherfacleave1_leave", limit: 8
    t.text    "otherfacleave1"
    t.text    "otherfacleave1txt"
    t.integer "otherfacleave2_leave", limit: 8
    t.text    "otherfacleave2"
    t.text    "otherfacleave2txt"
    t.integer "numqipgy1res",         limit: 8
    t.integer "numqipgy2res",         limit: 8
    t.integer "numqipgy3res",         limit: 8
    t.integer "numqipgy4res",         limit: 8
    t.integer "numrschpgy1res",       limit: 8
    t.integer "numrschpgy2res",       limit: 8
    t.integer "numrschpgy3res",       limit: 8
    t.integer "numrschpgy4res",       limit: 8
    t.integer "nopgy4",               limit: 8
    t.decimal "pctpeerreview"
    t.decimal "pctnonpeerreview"
    t.decimal "pctpresenting"
    t.integer "rps",                  limit: 8
    t.integer "ratefacdevel",         limit: 8
    t.integer "ratefacmorale",        limit: 8
    t.integer "rateresmorale",        limit: 8
    t.integer "ratesatisfaction",     limit: 8
  end

  create_table "y3_resident_responses", force: :cascade do |t|
    t.string  "p4residency_abfm_id",                null: false
    t.string  "p4_program_id"
    t.integer "abfm_last_four",           limit: 8
    t.string  "p4resid"
    t.string  "abfm_resident_responses"
    t.string  "contclin"
    t.integer "age",                      limit: 8
    t.integer "gender",                   limit: 8
    t.integer "race_c",                   limit: 8
    t.integer "race_aa",                  limit: 8
    t.integer "race_ap",                  limit: 8
    t.integer "race_in",                  limit: 8
    t.integer "race_o",                   limit: 8
    t.string  "raceothertxt"
    t.integer "ethnicity",                limit: 8
    t.integer "marital",                  limit: 8
    t.integer "children",                 limit: 8
    t.integer "many",                     limit: 8
    t.integer "medicalafterbs",           limit: 8
    t.decimal "yearsbeforemedschool"
    t.string  "describebeforemed"
    t.integer "usamedschool",             limit: 8
    t.integer "firstgenerationcollege",   limit: 8
    t.integer "firstgenphysician",        limit: 8
    t.integer "firstfamilyphysician",     limit: 8
    t.string  "medgraddate"
    t.integer "programyear",              limit: 8
    t.string  "otherprogramyear"
    t.integer "influence",                limit: 8
    t.integer "masters",                  limit: 8
    t.string  "mastersdegree"
    t.string  "mastersdegreeother"
    t.integer "goals",                    limit: 8
    t.integer "facultyteaching",          limit: 8
    t.integer "facultysupervising",       limit: 8
    t.integer "participationjournalclub", limit: 8
    t.integer "participationconferences", limit: 8
    t.integer "feedback",                 limit: 8
    t.integer "evaluatefaculty",          limit: 8
    t.integer "evaluateprogram",          limit: 8
    t.integer "speakfreely",              limit: 8
    t.integer "othertraineesinterfere",   limit: 8
    t.integer "satisfied",                limit: 8
    t.integer "strengthsfacteaching",     limit: 8
    t.integer "strengthsoverallcurr",     limit: 8
    t.integer "strengthscurrchange",      limit: 8
    t.integer "strengthspracchange",      limit: 8
    t.integer "strengthscompetence",      limit: 8
    t.integer "strengthsp4innovations",   limit: 8
    t.integer "strengthsp4implement",     limit: 8
    t.integer "importance1",              limit: 8
    t.integer "importance2",              limit: 8
    t.integer "importance3",              limit: 8
    t.integer "importance4",              limit: 8
    t.integer "importance5",              limit: 8
    t.integer "importance6",              limit: 8
    t.integer "importance7",              limit: 8
    t.integer "importance8",              limit: 8
    t.integer "importance9",              limit: 8
    t.integer "importance10",             limit: 8
    t.integer "importance11",             limit: 8
    t.integer "importance12",             limit: 8
    t.integer "importance13",             limit: 8
    t.integer "importance14",             limit: 8
    t.integer "importance15",             limit: 8
    t.integer "importance16",             limit: 8
    t.integer "importance17",             limit: 8
    t.integer "importance18",             limit: 8
    t.integer "importance19",             limit: 8
    t.integer "importance20",             limit: 8
    t.integer "importance21",             limit: 8
    t.integer "importance22",             limit: 8
    t.integer "importance23",             limit: 8
    t.integer "importance24",             limit: 8
    t.integer "importance25",             limit: 8
    t.integer "importance26",             limit: 8
    t.integer "importance27",             limit: 8
    t.integer "p4_resident_id"
  end

  create_table "y4_continuity_clinics", id: false, force: :cascade do |t|
    t.string  "p4_program_id",                       null: false
    t.string  "settingid",                           null: false
    t.integer "pgy1",                      limit: 8
    t.integer "pgy2",                      limit: 8
    t.integer "pgy3",                      limit: 8
    t.integer "pgy4",                      limit: 8
    t.integer "nopgy4",                    limit: 8
    t.integer "ptassigned",                limit: 8
    t.decimal "pgy1routine"
    t.decimal "pgy2routine"
    t.decimal "pgy3routine"
    t.decimal "pgy4routine"
    t.decimal "pgy1acute"
    t.decimal "pgy2acute"
    t.decimal "pgy3acute"
    t.decimal "pgy4acute"
    t.decimal "daysnewapptfac3"
    t.integer "daysnewapptfac3_unknown",   limit: 8
    t.decimal "daysnewapptres3"
    t.integer "daysnewapptres3_unknown",   limit: 8
    t.decimal "daysfuapptfac3"
    t.integer "daysfuapptfac3_unknown",    limit: 8
    t.decimal "daysfuapptres3"
    t.integer "daysfuapptres3_unknown",    limit: 8
    t.decimal "daysacuteapptfac3"
    t.integer "daysacuteapptfac3_unknown", limit: 8
    t.decimal "daysacuteapptres3"
    t.integer "daysacuteapptres3_unknown", limit: 8
    t.integer "numexamrooms",              limit: 8
    t.integer "numptfac",                  limit: 8
    t.integer "numptmid",                  limit: 8
    t.integer "numptres",                  limit: 8
    t.decimal "ftefp"
    t.decimal "ftefmres"
    t.decimal "fteped"
    t.decimal "ftepedres"
    t.decimal "fteim"
    t.decimal "fteimres"
    t.decimal "fteob"
    t.decimal "fteobres"
    t.integer "fteotherphys1_present",     limit: 8
    t.decimal "fteotherphys1"
    t.text    "fteotherphys1txt"
    t.integer "fteotherphys2_present",     limit: 8
    t.decimal "fteotherphys2"
    t.text    "fteotherphys2txt"
    t.decimal "ftenp"
    t.decimal "ftepa"
    t.decimal "fternlpn"
    t.decimal "ftema"
    t.decimal "fteallied"
    t.decimal "fteadmin"
    t.decimal "ftepsych"
    t.decimal "ftesocial"
    t.decimal "ftediet"
    t.decimal "ftepteduc"
    t.decimal "ftepharm"
    t.integer "fteotherspec1_present",     limit: 8
    t.decimal "fteotherspec1"
    t.text    "fteotherspec1txt"
    t.integer "fteotherspec2_present",     limit: 8
    t.decimal "fteotherspec2"
    t.text    "fteotherspec2txt"
    t.integer "numnp",                     limit: 8
    t.integer "numpa",                     limit: 8
    t.integer "numrnlpn",                  limit: 8
    t.integer "numma",                     limit: 8
    t.integer "numallied",                 limit: 8
    t.integer "numpsych",                  limit: 8
    t.integer "numsocial",                 limit: 8
    t.integer "numdiet",                   limit: 8
    t.integer "numpteduc",                 limit: 8
    t.decimal "numotherspec_present"
    t.integer "numotherspec",              limit: 8
    t.text    "numotherspectxt"
    t.decimal "numotherspec2_present"
    t.integer "numotherspec2",             limit: 8
    t.text    "numotherspec2txt"
    t.integer "integrated",                limit: 8
    t.integer "owner",                     limit: 8
    t.text    "ownerother"
    t.decimal "male"
    t.decimal "female"
    t.text    "gendersource"
    t.decimal "lt3"
    t.decimal "three"
    t.decimal "eighteen"
    t.decimal "twentyfive"
    t.decimal "fortyfive"
    t.decimal "sixtyfive"
    t.decimal "seventyfive"
    t.text    "agesource"
    t.decimal "hispanic"
    t.decimal "nonhispanic"
    t.text    "ethnicitysource"
    t.decimal "indian"
    t.decimal "asian"
    t.decimal "black"
    t.decimal "hawaiian"
    t.decimal "white"
    t.integer "otherrace_present",         limit: 8
    t.decimal "otherrace"
    t.text    "otherracetxt"
    t.text    "racesource"
    t.decimal "prepaid"
    t.decimal "ffs"
    t.decimal "medicare"
    t.decimal "medicaid"
    t.integer "otherpay_present",          limit: 8
    t.decimal "otherpay"
    t.text    "otherpaytxt"
    t.decimal "uninsured"
    t.text    "paysource"
    t.integer "xrays",                     limit: 8
    t.integer "statemr",                   limit: 8
    t.integer "statpaperless",             limit: 8
    t.integer "statremote",                limit: 8
    t.integer "stattranscription",         limit: 8
    t.integer "statscheduling",            limit: 8
    t.integer "statbilling",               limit: 8
    t.integer "statorders",                limit: 8
    t.integer "stathospemr",               limit: 8
    t.integer "statptcommunication",       limit: 8
    t.integer "statprovcommunication",     limit: 8
    t.integer "statqa",                    limit: 8
    t.integer "statdisregistry",           limit: 8
    t.integer "statprevregistry",          limit: 8
    t.integer "statresearch",              limit: 8
    t.integer "statopenaccess",            limit: 8
    t.integer "statexpandedhrs",           limit: 8
    t.integer "stattelephone",             limit: 8
    t.integer "statnetscheduling",         limit: 8
    t.integer "statsurvey",                limit: 8
    t.integer "statspace",                 limit: 8
    t.integer "statparking",               limit: 8
    t.integer "stattransit",               limit: 8
    t.integer "statteams",                 limit: 8
    t.integer "statpsych",                 limit: 8
    t.integer "statcasemgt",               limit: 8
    t.integer "statpharm",                 limit: 8
    t.integer "statgroup",                 limit: 8
    t.integer "statptcentered",            limit: 8
    t.integer "emrimplemented",            limit: 8
    t.decimal "emryears"
    t.text    "emrexplain"
    t.integer "emrptsafety",               limit: 8
    t.text    "emrptsafetytxt"
    t.integer "emr_demographic",           limit: 8
    t.integer "emr_ht_wt",                 limit: 8
    t.integer "emr_dxlist",                limit: 8
    t.integer "emr_active_meds",           limit: 8
    t.integer "emr_allergies",             limit: 8
    t.integer "emr_smoking",               limit: 8
    t.integer "emr_electronic_copy",       limit: 8
    t.integer "emr_electronic_rx",         limit: 8
    t.integer "emr_rx_cpoe",               limit: 8
    t.integer "emr_interaction_check",     limit: 8
    t.integer "emr_electronic_exchange",   limit: 8
    t.integer "emr_ds_compliance",         limit: 8
    t.integer "emr_privacy_security",      limit: 8
    t.integer "emr_aggregate_cqm",         limit: 8
    t.integer "emr_formulary_check",       limit: 8
    t.integer "emr_labs_numerical",        limit: 8
    t.integer "emr_ptlist_by_condition",   limit: 8
    t.integer "emr_pt_education",          limit: 8
    t.integer "emr_med_reconciliation",    limit: 8
    t.integer "emr_summary_of_care",       limit: 8
    t.integer "emr_immunization",          limit: 8
    t.integer "emr_syndromic_surveil",     limit: 8
    t.integer "emr_advance_dir",           limit: 8
    t.integer "emr_reportable_labs",       limit: 8
    t.integer "emr_appt_reminders",        limit: 8
    t.integer "emr_pt_electronic",         limit: 8
    t.string  "pcmhapplied"
    t.string  "pcmhstatus"
    t.string  "pcmhsubmitdate"
    t.string  "pcmhactiondate"
    t.string  "pcmhobtaindate"
  end

  add_index "y4_continuity_clinics", ["settingid"], name: "y4_continuity_clinics_settingid_key", unique: true, using: :btree

  create_table "y4_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y4_residency_programs", primary_key: "p4_program_id", force: :cascade do |t|
    t.integer "resleave",             limit: 8
    t.integer "resleavepgy1",         limit: 8
    t.integer "resleavepgy2",         limit: 8
    t.integer "resleavepgy3",         limit: 8
    t.integer "resleavepgy4",         limit: 8
    t.integer "facleave",             limit: 8
    t.integer "progdir_leave",        limit: 8
    t.text    "progdir"
    t.integer "siteeval_leave",       limit: 8
    t.text    "siteeval"
    t.integer "assocprogdir_leave",   limit: 8
    t.text    "assocprogdir"
    t.integer "rescoord_leave",       limit: 8
    t.text    "rescoord"
    t.integer "otherfacleave1_leave", limit: 8
    t.text    "otherfacleave1"
    t.text    "otherfacleave1txt"
    t.integer "otherfacleave2_leave", limit: 8
    t.text    "otherfacleave2"
    t.text    "otherfacleave2txt"
    t.integer "numqipgy1res",         limit: 8
    t.integer "numqipgy2res",         limit: 8
    t.integer "numqipgy3res",         limit: 8
    t.integer "numqipgy4res",         limit: 8
    t.integer "numrschpgy1res",       limit: 8
    t.integer "numrschpgy2res",       limit: 8
    t.integer "numrschpgy3res",       limit: 8
    t.integer "numrschpgy4res",       limit: 8
    t.integer "nopgy4",               limit: 8
    t.decimal "pctpeerreview"
    t.decimal "pctnonpeerreview"
    t.decimal "pctpresenting"
    t.integer "rps",                  limit: 8
    t.integer "ratefacdevel",         limit: 8
    t.integer "ratefacmorale",        limit: 8
    t.integer "rateresmorale",        limit: 8
    t.integer "ratesatisfaction",     limit: 8
  end

  create_table "y4_resident_responses", force: :cascade do |t|
    t.string  "p4residency_abfm_id",                null: false
    t.string  "contclin"
    t.string  "p4_program_id"
    t.integer "abfm_last_four",           limit: 8
    t.integer "age",                      limit: 8
    t.integer "gender",                   limit: 8
    t.integer "race_c",                   limit: 8
    t.integer "race_aa",                  limit: 8
    t.integer "race_ap",                  limit: 8
    t.integer "race_in",                  limit: 8
    t.integer "race_o",                   limit: 8
    t.string  "raceothertxt"
    t.integer "ethnicity",                limit: 8
    t.integer "marital",                  limit: 8
    t.integer "children",                 limit: 8
    t.integer "many",                     limit: 8
    t.integer "medicalafterbs",           limit: 8
    t.decimal "yearsbeforemedschool"
    t.string  "describebeforemed"
    t.integer "usamedschool",             limit: 8
    t.integer "firstgenerationcollege",   limit: 8
    t.integer "firstgenphysician",        limit: 8
    t.integer "firstfamilyphysician",     limit: 8
    t.string  "medgraddate"
    t.integer "programyear",              limit: 8
    t.string  "otherprogramyear"
    t.integer "influence",                limit: 8
    t.integer "masters",                  limit: 8
    t.string  "mastersdegree"
    t.string  "mastersdegreeother"
    t.integer "goals",                    limit: 8
    t.integer "facultyteaching",          limit: 8
    t.integer "facultysupervising",       limit: 8
    t.integer "participationjournalclub", limit: 8
    t.integer "participationconferences", limit: 8
    t.integer "feedback",                 limit: 8
    t.integer "evaluatefaculty",          limit: 8
    t.integer "evaluateprogram",          limit: 8
    t.integer "speakfreely",              limit: 8
    t.integer "othertraineesinterfere",   limit: 8
    t.integer "satisfied",                limit: 8
    t.integer "strengthsfacteaching",     limit: 8
    t.integer "strengthsoverallcurr",     limit: 8
    t.integer "strengthscurrchange",      limit: 8
    t.integer "strengthspracchange",      limit: 8
    t.integer "strengthscompetence",      limit: 8
    t.integer "strengthsp4innovations",   limit: 8
    t.integer "strengthsp4implement",     limit: 8
    t.integer "importance1",              limit: 8
    t.integer "importance2",              limit: 8
    t.integer "importance3",              limit: 8
    t.integer "importance4",              limit: 8
    t.integer "importance5",              limit: 8
    t.integer "importance6",              limit: 8
    t.integer "importance7",              limit: 8
    t.integer "importance8",              limit: 8
    t.integer "importance9",              limit: 8
    t.integer "importance10",             limit: 8
    t.integer "importance11",             limit: 8
    t.integer "importance12",             limit: 8
    t.integer "importance13",             limit: 8
    t.integer "importance14",             limit: 8
    t.integer "importance15",             limit: 8
    t.integer "importance16",             limit: 8
    t.integer "importance17",             limit: 8
    t.integer "importance18",             limit: 8
    t.integer "importance19",             limit: 8
    t.integer "importance20",             limit: 8
    t.integer "importance21",             limit: 8
    t.integer "importance22",             limit: 8
    t.integer "importance23",             limit: 8
    t.integer "importance24",             limit: 8
    t.integer "importance25",             limit: 8
    t.integer "importance26",             limit: 8
    t.integer "importance27",             limit: 8
    t.integer "p4_resident_id"
  end

  create_table "y5_continuity_clinics", id: false, force: :cascade do |t|
    t.string  "p4_program_id",                       null: false
    t.string  "settingid",                           null: false
    t.integer "pgy1",                      limit: 8
    t.integer "pgy2",                      limit: 8
    t.integer "pgy3",                      limit: 8
    t.integer "pgy4",                      limit: 8
    t.integer "nopgy4",                    limit: 8
    t.integer "ptassigned",                limit: 8
    t.decimal "pgy1routine"
    t.decimal "pgy2routine"
    t.decimal "pgy3routine"
    t.decimal "pgy4routine"
    t.decimal "pgy1acute"
    t.decimal "pgy2acute"
    t.decimal "pgy3acute"
    t.decimal "pgy4acute"
    t.decimal "daysnewapptfac3"
    t.integer "daysnewapptfac3_unknown",   limit: 8
    t.decimal "daysnewapptres3"
    t.integer "daysnewapptres3_unknown",   limit: 8
    t.decimal "daysfuapptfac3"
    t.integer "daysfuapptfac3_unknown",    limit: 8
    t.decimal "daysfuapptres3"
    t.integer "daysfuapptres3_unknown",    limit: 8
    t.decimal "daysacuteapptfac3"
    t.integer "daysacuteapptfac3_unknown", limit: 8
    t.decimal "daysacuteapptres3"
    t.integer "daysacuteapptres3_unknown", limit: 8
    t.integer "numexamrooms",              limit: 8
    t.integer "numptfac",                  limit: 8
    t.integer "numptmid",                  limit: 8
    t.integer "numptres",                  limit: 8
    t.decimal "ftefp"
    t.decimal "ftefmres"
    t.decimal "fteped"
    t.decimal "ftepedres"
    t.decimal "fteim"
    t.decimal "fteimres"
    t.decimal "fteob"
    t.decimal "fteobres"
    t.integer "fteotherphys1_present",     limit: 8
    t.decimal "fteotherphys1"
    t.text    "fteotherphys1txt"
    t.integer "fteotherphys2_present",     limit: 8
    t.decimal "fteotherphys2"
    t.text    "fteotherphys2txt"
    t.decimal "ftenp"
    t.decimal "ftepa"
    t.decimal "fternlpn"
    t.decimal "ftema"
    t.decimal "fteallied"
    t.decimal "fteadmin"
    t.decimal "ftepsych"
    t.decimal "ftesocial"
    t.decimal "ftediet"
    t.decimal "ftepteduc"
    t.decimal "ftepharm"
    t.integer "fteotherspec1_present",     limit: 8
    t.decimal "fteotherspec1"
    t.text    "fteotherspec1txt"
    t.integer "fteotherspec2_present",     limit: 8
    t.decimal "fteotherspec2"
    t.text    "fteotherspec2txt"
    t.integer "numnp",                     limit: 8
    t.integer "numpa",                     limit: 8
    t.integer "numrnlpn",                  limit: 8
    t.integer "numma",                     limit: 8
    t.integer "numallied",                 limit: 8
    t.integer "numpsych",                  limit: 8
    t.integer "numsocial",                 limit: 8
    t.integer "numdiet",                   limit: 8
    t.integer "numpteduc",                 limit: 8
    t.decimal "numotherspec_present"
    t.integer "numotherspec",              limit: 8
    t.text    "numotherspectxt"
    t.decimal "numotherspec2_present"
    t.integer "numotherspec2",             limit: 8
    t.text    "numotherspec2txt"
    t.integer "integrated",                limit: 8
    t.integer "owner",                     limit: 8
    t.text    "ownerother"
    t.decimal "male"
    t.decimal "female"
    t.text    "gendersource"
    t.decimal "lt3"
    t.decimal "three"
    t.decimal "eighteen"
    t.decimal "twentyfive"
    t.decimal "fortyfive"
    t.decimal "sixtyfive"
    t.decimal "seventyfive"
    t.text    "agesource"
    t.decimal "hispanic"
    t.decimal "nonhispanic"
    t.text    "ethnicitysource"
    t.decimal "indian"
    t.decimal "asian"
    t.decimal "black"
    t.decimal "hawaiian"
    t.decimal "white"
    t.integer "otherrace_present",         limit: 8
    t.decimal "otherrace"
    t.text    "otherracetxt"
    t.text    "racesource"
    t.decimal "prepaid"
    t.decimal "ffs"
    t.decimal "medicare"
    t.decimal "medicaid"
    t.integer "otherpay_present",          limit: 8
    t.decimal "otherpay"
    t.text    "otherpaytxt"
    t.decimal "uninsured"
    t.text    "paysource"
    t.integer "xrays",                     limit: 8
    t.integer "statemr",                   limit: 8
    t.integer "statpaperless",             limit: 8
    t.integer "statremote",                limit: 8
    t.integer "stattranscription",         limit: 8
    t.integer "statscheduling",            limit: 8
    t.integer "statbilling",               limit: 8
    t.integer "statorders",                limit: 8
    t.integer "stathospemr",               limit: 8
    t.integer "statptcommunication",       limit: 8
    t.integer "statprovcommunication",     limit: 8
    t.integer "statqa",                    limit: 8
    t.integer "statdisregistry",           limit: 8
    t.integer "statprevregistry",          limit: 8
    t.integer "statresearch",              limit: 8
    t.integer "statopenaccess",            limit: 8
    t.integer "statexpandedhrs",           limit: 8
    t.integer "stattelephone",             limit: 8
    t.integer "statnetscheduling",         limit: 8
    t.integer "statsurvey",                limit: 8
    t.integer "statspace",                 limit: 8
    t.integer "statparking",               limit: 8
    t.integer "stattransit",               limit: 8
    t.integer "statteams",                 limit: 8
    t.integer "statpsych",                 limit: 8
    t.integer "statcasemgt",               limit: 8
    t.integer "statpharm",                 limit: 8
    t.integer "statgroup",                 limit: 8
    t.integer "statptcentered",            limit: 8
    t.integer "emrimplemented",            limit: 8
    t.decimal "emryears"
    t.text    "emrexplain"
    t.integer "emrptsafety",               limit: 8
    t.text    "emrptsafetytxt"
    t.integer "emr_demographic",           limit: 8
    t.integer "emr_ht_wt",                 limit: 8
    t.integer "emr_dxlist",                limit: 8
    t.integer "emr_active_meds",           limit: 8
    t.integer "emr_allergies",             limit: 8
    t.integer "emr_smoking",               limit: 8
    t.integer "emr_electronic_copy",       limit: 8
    t.integer "emr_electronic_rx",         limit: 8
    t.integer "emr_rx_cpoe",               limit: 8
    t.integer "emr_interaction_check",     limit: 8
    t.integer "emr_electronic_exchange",   limit: 8
    t.integer "emr_ds_compliance",         limit: 8
    t.integer "emr_privacy_security",      limit: 8
    t.integer "emr_aggregate_cqm",         limit: 8
    t.integer "emr_formulary_check",       limit: 8
    t.integer "emr_labs_numerical",        limit: 8
    t.integer "emr_ptlist_by_condition",   limit: 8
    t.integer "emr_pt_education",          limit: 8
    t.integer "emr_med_reconciliation",    limit: 8
    t.integer "emr_summary_of_care",       limit: 8
    t.integer "emr_immunization",          limit: 8
    t.integer "emr_syndromic_surveil",     limit: 8
    t.integer "emr_advance_dir",           limit: 8
    t.integer "emr_reportable_labs",       limit: 8
    t.integer "emr_appt_reminders",        limit: 8
    t.integer "emr_pt_electronic",         limit: 8
    t.string  "pcmhapplied"
    t.string  "pcmhstatus"
    t.string  "pcmhsubmitdate"
    t.string  "pcmhactiondate"
    t.string  "pcmhobtaindate"
  end

  add_index "y5_continuity_clinics", ["settingid"], name: "y5_continuity_clinics_settingid_key", unique: true, using: :btree

  create_table "y5_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y5_residency_programs", primary_key: "p4_program_id", force: :cascade do |t|
    t.integer "resleave",             limit: 8
    t.integer "resleavepgy1",         limit: 8
    t.integer "resleavepgy2",         limit: 8
    t.integer "resleavepgy3",         limit: 8
    t.integer "resleavepgy4",         limit: 8
    t.integer "facleave",             limit: 8
    t.integer "progdir_leave",        limit: 8
    t.text    "progdir"
    t.integer "siteeval_leave",       limit: 8
    t.text    "siteeval"
    t.integer "assocprogdir_leave",   limit: 8
    t.text    "assocprogdir"
    t.integer "rescoord_leave",       limit: 8
    t.text    "rescoord"
    t.integer "otherfacleave1_leave", limit: 8
    t.text    "otherfacleave1"
    t.text    "otherfacleave1txt"
    t.integer "otherfacleave2_leave", limit: 8
    t.text    "otherfacleave2"
    t.text    "otherfacleave2txt"
    t.integer "numqipgy1res",         limit: 8
    t.integer "numqipgy2res",         limit: 8
    t.integer "numqipgy3res",         limit: 8
    t.integer "numqipgy4res",         limit: 8
    t.integer "numrschpgy1res",       limit: 8
    t.integer "numrschpgy2res",       limit: 8
    t.integer "numrschpgy3res",       limit: 8
    t.integer "numrschpgy4res",       limit: 8
    t.integer "nopgy4",               limit: 8
    t.decimal "pctpeerreview"
    t.decimal "pctnonpeerreview"
    t.decimal "pctpresenting"
    t.integer "rps",                  limit: 8
    t.integer "ratefacdevel",         limit: 8
    t.integer "ratefacmorale",        limit: 8
    t.integer "rateresmorale",        limit: 8
    t.integer "ratesatisfaction",     limit: 8
  end

  create_table "y5_resident_responses", force: :cascade do |t|
    t.string  "p4residency_abfm_id",                null: false
    t.string  "p4_program_id"
    t.string  "contclin"
    t.integer "abfm_last_four",           limit: 8
    t.integer "age",                      limit: 8
    t.integer "gender",                   limit: 8
    t.integer "race_c",                   limit: 8
    t.integer "race_aa",                  limit: 8
    t.integer "race_ap",                  limit: 8
    t.integer "race_in",                  limit: 8
    t.integer "race_o",                   limit: 8
    t.string  "raceothertxt"
    t.integer "ethnicity",                limit: 8
    t.integer "marital",                  limit: 8
    t.integer "children",                 limit: 8
    t.integer "many",                     limit: 8
    t.integer "medicalafterbs",           limit: 8
    t.decimal "yearsbeforemedschool"
    t.string  "describebeforemed"
    t.integer "usamedschool",             limit: 8
    t.integer "firstgenerationcollege",   limit: 8
    t.integer "firstgenphysician",        limit: 8
    t.integer "firstfamilyphysician",     limit: 8
    t.string  "medgraddate"
    t.integer "programyear",              limit: 8
    t.string  "otherprogramyear"
    t.integer "influence",                limit: 8
    t.integer "masters",                  limit: 8
    t.string  "mastersdegree"
    t.string  "mastersdegreeother"
    t.integer "goals",                    limit: 8
    t.integer "facultyteaching",          limit: 8
    t.integer "facultysupervising",       limit: 8
    t.integer "participationjournalclub", limit: 8
    t.integer "participationconferences", limit: 8
    t.integer "feedback",                 limit: 8
    t.integer "evaluatefaculty",          limit: 8
    t.integer "evaluateprogram",          limit: 8
    t.integer "speakfreely",              limit: 8
    t.integer "othertraineesinterfere",   limit: 8
    t.integer "satisfied",                limit: 8
    t.integer "strengthsfacteaching",     limit: 8
    t.integer "strengthsoverallcurr",     limit: 8
    t.integer "strengthscurrchange",      limit: 8
    t.integer "strengthspracchange",      limit: 8
    t.integer "strengthscompetence",      limit: 8
    t.integer "strengthsp4innovations",   limit: 8
    t.integer "strengthsp4implement",     limit: 8
    t.integer "importance1",              limit: 8
    t.integer "importance2",              limit: 8
    t.integer "importance3",              limit: 8
    t.integer "importance4",              limit: 8
    t.integer "importance5",              limit: 8
    t.integer "importance6",              limit: 8
    t.integer "importance7",              limit: 8
    t.integer "importance8",              limit: 8
    t.integer "importance9",              limit: 8
    t.integer "importance10",             limit: 8
    t.integer "importance11",             limit: 8
    t.integer "importance12",             limit: 8
    t.integer "importance13",             limit: 8
    t.integer "importance14",             limit: 8
    t.integer "importance15",             limit: 8
    t.integer "importance16",             limit: 8
    t.integer "importance17",             limit: 8
    t.integer "importance18",             limit: 8
    t.integer "importance19",             limit: 8
    t.integer "importance20",             limit: 8
    t.integer "importance21",             limit: 8
    t.integer "importance22",             limit: 8
    t.integer "importance23",             limit: 8
    t.integer "importance24",             limit: 8
    t.integer "importance25",             limit: 8
    t.integer "importance26",             limit: 8
    t.integer "importance27",             limit: 8
    t.integer "p4_resident_id"
  end

  create_table "y6_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  create_table "y7_graduate_responses", force: :cascade do |t|
    t.integer "graduateid",          limit: 8
    t.string  "p4_program_id"
    t.integer "grad_year",           limit: 8
    t.integer "abfm_last_four",      limit: 8
    t.integer "paper",               limit: 8
    t.integer "finished",            limit: 8
    t.integer "max_slide",           limit: 8
    t.string  "created_at"
    t.string  "updated_at"
    t.integer "q101a",               limit: 8
    t.integer "q101b",               limit: 8
    t.integer "q101c",               limit: 8
    t.integer "q101d",               limit: 8
    t.integer "q102a",               limit: 8
    t.integer "q102b",               limit: 8
    t.integer "q102c",               limit: 8
    t.integer "q102d",               limit: 8
    t.string  "q102d_other"
    t.integer "q103a",               limit: 8
    t.integer "q103b_1",             limit: 8
    t.integer "q103b_2",             limit: 8
    t.integer "q103b_3",             limit: 8
    t.integer "q103b_4",             limit: 8
    t.integer "q103b_5",             limit: 8
    t.integer "q103b_6",             limit: 8
    t.integer "q103b_7",             limit: 8
    t.integer "q103b_8",             limit: 8
    t.integer "q103b_9",             limit: 8
    t.integer "q103b_10",            limit: 8
    t.string  "q103b_other"
    t.string  "q104"
    t.decimal "q105"
    t.integer "q106",                limit: 8
    t.integer "q107_1",              limit: 8
    t.integer "q107_2",              limit: 8
    t.integer "q107_3",              limit: 8
    t.integer "q107_4",              limit: 8
    t.integer "q107_5",              limit: 8
    t.integer "q107_6",              limit: 8
    t.integer "q107_7",              limit: 8
    t.string  "q107_other"
    t.integer "q108",                limit: 8
    t.integer "q201",                limit: 8
    t.string  "q201_other"
    t.integer "q202_a",              limit: 8
    t.integer "q202_b",              limit: 8
    t.integer "q202_c",              limit: 8
    t.integer "q202_d",              limit: 8
    t.integer "q202_e",              limit: 8
    t.integer "q202_f",              limit: 8
    t.integer "q202_g",              limit: 8
    t.integer "q202_h",              limit: 8
    t.string  "q202_other"
    t.integer "q202_none",           limit: 8
    t.integer "q203",                limit: 8
    t.decimal "q204"
    t.integer "q205",                limit: 8
    t.decimal "q206"
    t.decimal "q207a"
    t.decimal "q207b"
    t.decimal "q207c"
    t.decimal "q207d"
    t.decimal "q207e"
    t.decimal "q207f"
    t.integer "q207f_other_present", limit: 8
    t.string  "q207f_other"
    t.integer "q208",                limit: 8
    t.integer "q301a",               limit: 8
    t.integer "q301b",               limit: 8
    t.integer "q301c",               limit: 8
    t.integer "q301d",               limit: 8
    t.integer "q401",                limit: 8
    t.integer "q402",                limit: 8
    t.integer "q403",                limit: 8
    t.integer "q404",                limit: 8
    t.integer "q405",                limit: 8
    t.integer "q406",                limit: 8
    t.integer "q407",                limit: 8
    t.integer "q408",                limit: 8
    t.integer "q409",                limit: 8
    t.integer "q410",                limit: 8
    t.integer "q411",                limit: 8
    t.integer "q412",                limit: 8
    t.integer "q413",                limit: 8
    t.integer "q414",                limit: 8
    t.integer "q415",                limit: 8
    t.integer "q416",                limit: 8
    t.integer "q417",                limit: 8
    t.integer "q418",                limit: 8
    t.integer "q419",                limit: 8
    t.integer "q420",                limit: 8
    t.integer "q421",                limit: 8
    t.integer "q422",                limit: 8
    t.integer "q423",                limit: 8
    t.integer "q424",                limit: 8
    t.integer "q425",                limit: 8
    t.integer "q426",                limit: 8
    t.integer "q427",                limit: 8
    t.integer "q428",                limit: 8
    t.integer "q429",                limit: 8
    t.integer "q430",                limit: 8
    t.integer "q501a",               limit: 8
    t.integer "q501b",               limit: 8
    t.integer "q501c",               limit: 8
    t.integer "q501d",               limit: 8
    t.integer "q501e",               limit: 8
    t.integer "q501f",               limit: 8
    t.integer "q501g",               limit: 8
    t.integer "q502",                limit: 8
    t.integer "q503",                limit: 8
    t.integer "q503_group",          limit: 8
    t.integer "q503a",               limit: 8
    t.integer "q503b",               limit: 8
    t.integer "q504",                limit: 8
    t.string  "q504_describe"
    t.integer "q505_1",              limit: 8
    t.integer "q505_2",              limit: 8
    t.integer "q505_3",              limit: 8
    t.integer "q505_4",              limit: 8
    t.string  "q505_other"
    t.integer "q505_none",           limit: 8
    t.integer "q506a",               limit: 8
    t.integer "q506a_practiced",     limit: 8
    t.integer "q506b",               limit: 8
    t.integer "q506b_practiced",     limit: 8
    t.integer "q506c",               limit: 8
    t.integer "q506c_practiced",     limit: 8
    t.integer "q506d",               limit: 8
    t.integer "q506d_practiced",     limit: 8
    t.integer "q506e",               limit: 8
    t.integer "q506e_practiced",     limit: 8
    t.integer "q507a",               limit: 8
    t.integer "q507a_practiced",     limit: 8
    t.integer "q507b",               limit: 8
    t.integer "q507b_practiced",     limit: 8
    t.integer "q507c",               limit: 8
    t.integer "q507c_practiced",     limit: 8
    t.integer "q507d",               limit: 8
    t.integer "q507d_practiced",     limit: 8
    t.integer "q507e",               limit: 8
    t.integer "q507e_practiced",     limit: 8
    t.integer "q507f",               limit: 8
    t.integer "q507f_practiced",     limit: 8
    t.integer "q507g",               limit: 8
    t.integer "q507g_practiced",     limit: 8
    t.integer "q507h",               limit: 8
    t.integer "q507h_practiced",     limit: 8
    t.integer "q507i",               limit: 8
    t.integer "q507i_practiced",     limit: 8
    t.integer "q507j",               limit: 8
    t.integer "q507j_practiced",     limit: 8
    t.integer "q508a",               limit: 8
    t.integer "q508a_practiced",     limit: 8
    t.integer "q508b",               limit: 8
    t.integer "q508b_practiced",     limit: 8
    t.integer "q508c",               limit: 8
    t.integer "q508c_practiced",     limit: 8
    t.integer "q508d",               limit: 8
    t.integer "q508d_practiced",     limit: 8
    t.integer "q508e",               limit: 8
    t.integer "q508e_practiced",     limit: 8
    t.integer "q508f",               limit: 8
    t.integer "q508f_practiced",     limit: 8
    t.integer "q508g",               limit: 8
    t.integer "q508g_practiced",     limit: 8
    t.integer "q509a",               limit: 8
    t.integer "q509a_practiced",     limit: 8
    t.integer "q509b",               limit: 8
    t.integer "q509b_practiced",     limit: 8
    t.integer "q509c",               limit: 8
    t.integer "q509c_practiced",     limit: 8
    t.integer "q510a",               limit: 8
    t.integer "q510a_practiced",     limit: 8
    t.integer "q510b",               limit: 8
    t.integer "q510b_practiced",     limit: 8
    t.integer "q510c",               limit: 8
    t.integer "q510c_practiced",     limit: 8
    t.integer "q510d",               limit: 8
    t.integer "q510d_practiced",     limit: 8
    t.integer "q510e",               limit: 8
    t.integer "q510e_practiced",     limit: 8
    t.integer "q510f",               limit: 8
    t.integer "q510f_practiced",     limit: 8
    t.integer "q510g",               limit: 8
    t.integer "q510g_practiced",     limit: 8
    t.integer "q510h",               limit: 8
    t.integer "q510h_practiced",     limit: 8
    t.integer "q511a",               limit: 8
    t.integer "q511a_practiced",     limit: 8
    t.integer "q511b",               limit: 8
    t.integer "q511b_practiced",     limit: 8
    t.integer "q511c",               limit: 8
    t.integer "q511c_practiced",     limit: 8
    t.integer "q512a",               limit: 8
    t.integer "q512a_practiced",     limit: 8
    t.integer "q512b",               limit: 8
    t.integer "q512b_practiced",     limit: 8
    t.integer "q513a",               limit: 8
    t.integer "q513a_practiced",     limit: 8
    t.integer "q513b",               limit: 8
    t.integer "q513b_practiced",     limit: 8
    t.integer "q513c",               limit: 8
    t.integer "q513c_practiced",     limit: 8
    t.integer "q513d",               limit: 8
    t.integer "q513d_practiced",     limit: 8
    t.integer "q513e",               limit: 8
    t.integer "q513e_practiced",     limit: 8
    t.integer "q514a",               limit: 8
    t.integer "q514a_practiced",     limit: 8
    t.integer "q514b",               limit: 8
    t.integer "q514b_practiced",     limit: 8
    t.integer "q514c",               limit: 8
    t.integer "q514c_practiced",     limit: 8
    t.integer "q514d",               limit: 8
    t.integer "q514d_practiced",     limit: 8
    t.integer "q514e",               limit: 8
    t.integer "q514e_practiced",     limit: 8
    t.integer "q514f",               limit: 8
    t.integer "q514f_practiced",     limit: 8
    t.integer "q514g",               limit: 8
    t.integer "q514g_practiced",     limit: 8
    t.integer "q514h",               limit: 8
    t.integer "q514h_practiced",     limit: 8
    t.integer "q514i",               limit: 8
    t.integer "q514i_practiced",     limit: 8
    t.integer "q514j",               limit: 8
    t.integer "q514j_practiced",     limit: 8
    t.integer "q601a",               limit: 8
    t.integer "q601a_practiced",     limit: 8
    t.integer "q601b",               limit: 8
    t.integer "q601b_practiced",     limit: 8
    t.integer "q601c",               limit: 8
    t.integer "q601c_practiced",     limit: 8
    t.integer "q601d",               limit: 8
    t.integer "q601d_practiced",     limit: 8
    t.integer "q601e",               limit: 8
    t.integer "q601e_practiced",     limit: 8
    t.integer "q602a",               limit: 8
    t.integer "q602a_practiced",     limit: 8
    t.integer "q602b",               limit: 8
    t.integer "q602b_practiced",     limit: 8
    t.integer "q602c",               limit: 8
    t.integer "q602c_practiced",     limit: 8
    t.integer "q602d",               limit: 8
    t.integer "q602d_practiced",     limit: 8
    t.integer "q602e",               limit: 8
    t.integer "q602e_practiced",     limit: 8
    t.integer "q603a",               limit: 8
    t.integer "q603a_practiced",     limit: 8
    t.integer "q603b",               limit: 8
    t.integer "q603b_practiced",     limit: 8
    t.integer "q603c",               limit: 8
    t.integer "q603c_practiced",     limit: 8
    t.integer "q603d",               limit: 8
    t.integer "q603d_practiced",     limit: 8
    t.integer "q603e",               limit: 8
    t.integer "q603e_practiced",     limit: 8
    t.integer "q603f",               limit: 8
    t.integer "q603f_practiced",     limit: 8
    t.integer "q604a",               limit: 8
    t.integer "q604a_practiced",     limit: 8
    t.integer "q604b",               limit: 8
    t.integer "q604b_practiced",     limit: 8
    t.integer "q604c",               limit: 8
    t.integer "q604c_practiced",     limit: 8
    t.integer "q604d",               limit: 8
    t.integer "q604d_practiced",     limit: 8
    t.integer "q605a",               limit: 8
    t.integer "q605a_practiced",     limit: 8
    t.integer "q605b",               limit: 8
    t.integer "q605b_practiced",     limit: 8
    t.integer "q606a",               limit: 8
    t.integer "q606a_practiced",     limit: 8
    t.integer "q606b",               limit: 8
    t.integer "q606b_practiced",     limit: 8
    t.integer "q606c",               limit: 8
    t.integer "q606c_practiced",     limit: 8
    t.integer "q606d",               limit: 8
    t.integer "q606d_practiced",     limit: 8
    t.integer "q606e",               limit: 8
    t.integer "q606e_practiced",     limit: 8
    t.integer "q606f",               limit: 8
    t.integer "q606f_practiced",     limit: 8
    t.integer "q606g",               limit: 8
    t.integer "q606g_practiced",     limit: 8
    t.integer "q606h",               limit: 8
    t.integer "q606h_practiced",     limit: 8
    t.integer "q606i",               limit: 8
    t.integer "q606i_practiced",     limit: 8
    t.string  "q701"
    t.integer "p4_resident_id"
  end

  add_foreign_key "assignment_comments", "user_assignments"
  add_foreign_key "assignment_comments", "users"
  add_foreign_key "assignment_groups", "assignment_group_templates"
  add_foreign_key "assignment_groups", "users"
  add_foreign_key "p4_resident_clinics", "p4_clinics", primary_key: "p4_clinic_id", name: "clinic_exists"
  add_foreign_key "p4_resident_clinics", "p4_residents", name: "resident_exists"
  add_foreign_key "role_aggregates", "lime_surveys", column: "lime_survey_sid", primary_key: "sid", name: "lime_survey_sid_fk", on_delete: :cascade
  add_foreign_key "survey_assignments", "assignment_groups"
  add_foreign_key "survey_assignments", "lime_surveys", column: "lime_survey_sid", primary_key: "sid", on_delete: :cascade
  add_foreign_key "user_assignments", "survey_assignments", on_delete: :cascade
  add_foreign_key "y1_continuity_clinics", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y1_continuity_clinics_p4_program_id_fkey"
  add_foreign_key "y1_graduate_responses", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y1_graduate_responses_p4_program_id_fkey"
  add_foreign_key "y1_resident_responses", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y1_resident_responses_p4_program_id_fkey"
  add_foreign_key "y2_continuity_clinics", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y2_continuity_clinics_p4_program_id_fkey"
  add_foreign_key "y2_resident_responses", "y2_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y2_resident_responses_p4_program_id_fkey"
  add_foreign_key "y3_continuity_clinics", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y3_continuity_clinics_p4_program_id_fkey"
  add_foreign_key "y3_resident_responses", "y3_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y3_resident_responses_p4_program_id_fkey"
  add_foreign_key "y4_continuity_clinics", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y4_continuity_clinics_p4_program_id_fkey"
  add_foreign_key "y4_resident_responses", "y4_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y4_resident_responses_p4_program_id_fkey"
  add_foreign_key "y5_continuity_clinics", "y1_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y5_continuity_clinics_p4_program_id_fkey"
  add_foreign_key "y5_resident_responses", "y5_residency_programs", column: "p4_program_id", primary_key: "p4_program_id", name: "y5_resident_responses_p4_program_id_fkey"
end
