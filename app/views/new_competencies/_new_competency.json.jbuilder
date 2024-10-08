json.extract! new_competency, :id, :user_id, :permission_group_id, :student_uid, :email, :medhub_id, :course_name, :created_at, :updated_at
json.url new_competency_url(new_competency, format: :json)
