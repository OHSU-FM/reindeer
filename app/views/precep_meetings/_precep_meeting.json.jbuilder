json.extract! precep_meeting, :id, :student_sid, :student_name, :meeting_date, :meeting_notes, :meeting_with, :other_present, :created_at, :updated_at
json.url precep_meeting_url(precep_meeting, format: :json)
