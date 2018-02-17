$(document).on 'click', '#cs-sidebar-toggle', (e)->
  console.log('toggle')
  $('#cs-goals-nav').toggleClass('open')

$(document).on 'click', '#show-detail', (e)->
  console.log('show detail')
  $('#cs-goals-detail').toggleClass('show-goal-detail')

$(document).on 'click', '#hide-detail', (e)->
  console.log('hide detail')
  $('#cs-goals-detail').removeClass('show-goal-detail')

$(document).bind 'ajaxError', 'form#new_goal', (event, jqxhr, settings, exception) ->
  $(event.data).render_form_errors($.parseJSON(jqxhr.responseText))
  return

$(document).ready ->
  $("#student-select").select2()

$.fn.modal_success = () ->
  this.modal('hide')

  this.find('form input[type="text"]').val('')

  this.clear_previous_errors()

$.fn.render_form_errors = (errors) ->
  $form = this
  this.clear_previous_errors()
  model = this.data('modal')

  $.each errors, (field, messages) ->
    $input = $('input[name="' + model + '[' + field + ']"]')
    $input.closest('.form-group')
    .addClass('has-error')
    .find('.help-block')
    .html messages.join(' & ')

  return

$.fn.clear_previous_errors = () ->
  $('.form-group.has-error', this).each () ->
    $('.help-block', $(this)).html('')
    $(this).removeClass('has-error')
  return
