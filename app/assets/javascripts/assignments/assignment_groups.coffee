@Assignments.AssignmentGroup = {}

$.fn.modal.Constructor::enforceFocus = ->

$ ->
  $('.comment-row, .sys-comment-row').hover ->
    $(this).children('.comment-delete').toggle()

$ ->
  $(".needs-select2").select2({ width: "100%" });

$ ->
  $(".assignment-group-select").bind "change", ->
    url = $(this).val()
    if url
      window.location.replace url
    false
