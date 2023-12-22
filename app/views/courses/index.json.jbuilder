json.set! :data do
  json.array! @courses do |course|
    json.partial! 'courses/course', course: course
    json.url  "
              #{link_to 'Show', course }
              #{link_to 'Edit', edit_course_path(course)}
              #{link_to 'Destroy', course, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end