json.set! :data do
  json.array! @badging_dates do |badging_date|
    json.partial! 'badging_dates/badging_date', badging_date: badging_date
    json.url  "
              #{link_to 'Show', badging_date }
              #{link_to 'Edit', edit_badging_date_path(badging_date)}
              #{link_to 'Destroy', badging_date, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end