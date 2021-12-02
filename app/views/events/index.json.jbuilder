# print @events.inspect
# json.set! :data do
#   json.array! @events do |event|
#     json.partial! 'events/event', event: event
#     json.url  "
#               #{link_to 'Show', event }
#               #{link_to 'Edit', edit_event_path(event)}
#               #{link_to 'Destroy', event, method: :delete, data: { confirm: 'Are you sure?' }}
#               "
#   end
# end
json.array! @events do |event|
  json.extract! event, :id, :title, :description
  json.start event.start_date
  json.end event.end_date
  json.url event_url(event, format: :html)
end
