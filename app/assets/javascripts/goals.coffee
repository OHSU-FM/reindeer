
$(document).on 'click', '#cs-sidebar-toggle', (e) ->
  $('#cs-goals-nav').toggleClass('open')

$(document).on 'click', '#hide-detail', (e) ->
  $detail = $('#cs-detail')
  $detail.removeClass('show-detail')

$(document).on 'click', '.nav-item', (e) ->
  $('#cs-detail').removeClass('show-detail')

$ ->
  $("#student-select").select2()
  $('.show-detail-button').on 'click', () ->
    $('#cs-detail').addClass('show-detail')
    $('#loading-spinner').show()


$(document).on 'change', '.status-picker', (e) ->
  detailDiv = $(e.target).closest('div.show-detail')
  newStatus = e.target.value
  updatedDesc = $('.updateDesc').val()
  updatedNotes = $('.updateNotes').val()
  if $(e.target).attr('data-goalId')
    objectId = $(e.target).attr('data-goalId')
    controller = "goals"
    data = { g_status: newStatus, description:  updatedDesc}
  else
    objectId = $(e.target).attr('data-meetingId')
    controller = "meetings"
    data = { m_status: newStatus, notes: updatedNotes }

  xhr = $.ajax({
    url: "/coaching/" + controller + "/" + objectId
    method: "PUT",
    data: data,
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      $('div#cs-detail *').prop("disabled", true) # disable all children
      detailDiv.addClass('grayed-out')
  }).done((d) ->
    show_detail_message 'success', "Successfully updated status"
  ).fail((e, request) ->
    $('div#cs-detail *').prop("disabled", false); # re enable all children
    detailDiv.removeClass('grayed-out')
    show_detail_message 'error', "Sorry, something's gone wrong..."
  )

$(document).on 'click', '#goal_complete', (e) ->
  goalTable = $('.goals-table')
  completed = e.target.value
  uname = window.location.pathname.split("/").slice(-1)[0]
  $('input[name=goal_search').val('')
  xhr = $.ajax({
    url: "/coaching/students/" + uname + "/completed_goals"
    method: "POST",
    data: { completed_goal: e.target.checked },
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      $('tbody#goals-table *').prop("disabled", true) # disable all children
      $(e.target).closest('div.tab-content').addClass('grayed-out')
  }).done((d) ->
    show_detail_message 'success', "Successfully updated status"
  ).fail((request) ->
    $('tbody#goals-table *').prop("disabled", false); # re enable all children
    $('div.tab-content').removeClass('grayed-out')
    show_detail_message 'error', "Sorry, something's gone wrong..."
  )

$(document).on 'click', 'input[name=goal-search-btn]', (e) ->
  $('#goal_complete').prop('checked', false)

show_detail_message = (type, message) ->
  $("#detail-message").show()
  $("#detail-message").html "<div id='flash-#{type}'>#{message}</div>"
  $("#detail-message").delay(1000).slideUp 'slow'

$.fn.modal_success = () ->
  this.modal('hide')
  this.clear_previous_errors()

$.fn.clear_previous_errors = () ->
  $('.form-group.has-error', this).each () ->
    $('.help-block', $(this)).html('')
    $(this).removeClass('has-error')
  return

$(document).ready ->

  datefield = document.createElement('input')
  datefield.setAttribute 'type', 'date'
  if datefield.type != 'date'
    #if browser doesn't support input type="date", load files for jQuery UI Date Picker
    document.write '<link href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />\n'
    document.write '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>\n'
    document.write '<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>\n'
    #if browser doesn't support input type="date", initialize date picker widget:
    jQuery ($) ->
      #on document.ready
      $('#coaching_goal_target_date').datepicker()
      $('#coaching_meeting_date').datepicker()
      return


  $('a[data-toggle="tab"]').on 'show.bs.tab', (e) ->
    localStorage.setItem 'activeTab', $(e.target).attr('href')
    return
  activeTab = localStorage.getItem('activeTab')
  if activeTab
    console.log ("activeTab: " + activeTab)
    $('#myTab a[href="' + activeTab + '"]').tab 'show'
  return
