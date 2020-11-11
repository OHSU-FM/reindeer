json.set! :data do
  json.array! @advisors do |advisor|
    json.partial! 'advisors/advisor', advisor: advisor
    json.url  "
              #{link_to 'Show', advisor }
              #{link_to 'Edit', edit_advisor_path(advisor)}
              #{link_to 'Destroy', advisor, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end