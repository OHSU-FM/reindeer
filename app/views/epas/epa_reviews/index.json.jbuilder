json.set! :data do
  json.array! @epa_reviews do |epa_review|
    json.partial! 'epa_reviews/epa_review', epa_review: epa_review
    json.url  "
              #{link_to 'Show', epa_review }
              #{link_to 'Edit', edit_epa_review_path(epa_review)}
              #{link_to 'Destroy', epa_review, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end