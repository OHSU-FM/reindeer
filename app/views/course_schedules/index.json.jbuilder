json.set! :data do
  json.array! @course_schedules do |course_schedule|
    json.partial! 'course_schedules/course_schedule', course_schedule: course_schedule
    json.url  "
              #{link_to 'Show', course_schedule }
              #{link_to 'Edit', edit_course_schedule_path(course_schedule)}
              #{link_to 'Destroy', course_schedule, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end