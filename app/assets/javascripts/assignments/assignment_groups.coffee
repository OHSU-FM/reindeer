@Assignments.AssignmentGroup = {}

$.fn.modal.Constructor::enforceFocus = ->

$ ->
  $('.comment-row, .sys-comment-row').hover ->
    $(this).children('.comment-delete').toggle()
