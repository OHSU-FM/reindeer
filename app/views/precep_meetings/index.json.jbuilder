json.set! :data do
  json.array! @precep_meetings do |precep_meeting|
    json.partial! 'precep_meetings/precep_meeting', precep_meeting: precep_meeting
    json.url  "
              #{link_to 'Show', precep_meeting }
              #{link_to 'Edit', edit_precep_meeting_path(precep_meeting)}
              #{link_to 'Destroy', precep_meeting, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end