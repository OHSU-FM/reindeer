json.set! :data do
  json.array! @fom_remeds do |fom_remed|
    json.partial! 'fom_remeds/fom_remed', fom_remed: fom_remed
    json.url  "
              #{link_to 'Show', fom_remed }
              #{link_to 'Edit', edit_fom_remed_path(fom_remed)}
              #{link_to 'Destroy', fom_remed, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end