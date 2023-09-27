json.set! :data do
  json.array! @eg_members do |eg_member|
    json.partial! 'eg_members/eg_member', eg_member: eg_member
    json.url  "
              #{link_to 'Show', eg_member }
              #{link_to 'Edit', edit_eg_member_path(eg_member)}
              #{link_to 'Destroy', eg_member, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end