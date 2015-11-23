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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "lime_participant_attribute", id: false, force: :cascade do |t|
    t.string  "participant_id", limit: 50, null: false
    t.integer "attribute_id",              null: false
    t.text    "value",                     null: false
  end

  create_table "lime_participant_attribute_names", id: false, force: :cascade do |t|
    t.integer "attribute_id",              default: "nextval('lime_participant_attribute_names_attribute_id_seq'::regclass)", null: false
    t.string  "attribute_type", limit: 4,                                                                                     null: false
    t.string  "defaultname",    limit: 50,                                                                                    null: false
    t.string  "visible",        limit: 5,                                                                                     null: false
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
    t.string   "firstname",   limit: 150
    t.string   "lastname",    limit: 150
    t.string   "email",       limit: 254
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

end
