json.set! :data do
  json.array! @new_competencies do |new_competency|
    json.partial! 'new_competencies/new_competency', new_competency: new_competency
    json.url  "
              #{link_to 'Show', new_competency }
              #{link_to 'Edit', edit_new_competency_path(new_competency)}
              #{link_to 'Destroy', new_competency, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end