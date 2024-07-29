json.extract! course, :id, :course_number, :course_name, :content_type, :medhub_course_id, :rural, :created_at, :updated_at
json.url course_url(course, format: :json)
