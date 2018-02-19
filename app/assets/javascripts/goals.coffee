$(document).on 'click', '#cs-sidebar-toggle', (e) ->
  $('#cs-goals-nav').toggleClass('open')

$(document).on 'click', '#hide-detail', (e) ->
  $detail = $('#cs-goals-detail')
  $detail.removeClass('show-goal-detail')

$(document).ready ->
  $("#student-select").select2()

$.fn.modal_success = () ->
  this.modal('hide')
  this.find('form input[type="text"]').val('')
  this.clear_previous_errors()

$.fn.clear_previous_errors = () ->
  $('.form-group.has-error', this).each () ->
    $('.help-block', $(this)).html('')
    $(this).removeClass('has-error')
  return
