@Assignments.AssignmentGroup = {}

$.fn.modal.Constructor::enforceFocus = ->

$ ->
  $('.comment-row, .sys-comment-row').hover ->
    $(this).children('.comment-delete').toggle()

$ ->
  $(".needs-select2").select2({
    width: "100%",
    matcher: optGroupMatcher
  })
    .val('-1').trigger('change')

$ ->
  $(".collection-select").bind "change", ->
    url = $(this).val()
    if url
      window.location.replace url
    false

# http://stackoverflow.com/a/32084193
optGroupMatcher = (params, data) ->
  data.parentText = data.parentText or ''
  # Always return the object if there is nothing to compare

  if $.trim(params.term) == ''
    return data
  # Do a recursive check for options with children
  if data.children and data.children.length > 0
    # Clone the data object if there are children
    # This is required as we modify the object to remove any non-matches
    match = $.extend(true, {}, data)
    # Check each child of the option
    c = data.children.length - 1
    while c >= 0
      child = data.children[c]
      child.parentText += data.parentText + ' ' + data.text
      matches = optGroupMatcher(params, child)
      # If there wasn't a match, remove the object in the array
      if matches == null
        match.children.splice c, 1
      c--
    # If any children matched, return the new object
    if match.children.length > 0
      return match
    # If there were no matching children, check just the plain object
    return optGroupMatcher(params, match)
  # If the typed-in term matches the text of this term, or the text from any
  # parent term, then it's a match.
  original = (data.parentText + ' ' + data.text).toUpperCase()
  term = params.term.toUpperCase()
  # Check if the text contains the term
  if original.indexOf(term) > -1
    return data
  # If it doesn't contain the term, don't return anything
  null
