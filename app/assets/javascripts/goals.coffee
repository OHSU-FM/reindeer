
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


disable_input_fields = () ->
  coaching_type = $('.goals-header').data('coaching-type')
  #alert 'coaching_type (goals.coffee): ' + coaching_type
  $('#cs-detail *').prop 'disabled', false  #enable all unless it is a student
  if coaching_type == 'student'
    $('.MyCheckBox').prop('disabled', false)  # enable as student can modify
    $('.MyCheckBoxAdvisorDiscussed').prop('disabled', true)
    $('.MyCheckBoxAdvisorOutcomes').prop('disabled', true)
    $("input[type=text]").prop('disabled', true)
    $('.updateAdvisorNotes').prop('disabled', true)

$(document).on 'click', '#SaveMeeting', (e) ->
#$(document).on 'change', '.status-picker', (e) ->
  detailDiv = $(e.target).closest('div.show-detail')
  newStatus = $('.status-picker').val()   #e.target.value
  updatedDesc = $('.updateDesc').val()
  updatedNotes = $('.updateStudentNotes').val()
  updatedAdvisorNotes = $('.updateAdvisorNotes').val()
  updatedCareerDiscussedOther = $('#career_discussed_other').val()
  updatedCareerOutcomesOther = $('#career_outcomes_other').val()
  updatedAcademicDiscussedOther = $('#academic_discussed_other').val()
  updatedAcademicOutcomesOther = $('#academic_outcomes_other').val()
  updatedStudyResourcesOther = $('#study_resources_other').val()
  updatedAdvisorType = $('#advisor_type').data("advisor_type")

  console.log("Goal.coffee - advisor_type: " + updatedAdvisorType)
  console.log("advisor notes: " + updatedAdvisorNotes)

  # checked_subjects is an array
  checked_subjects = do ->
    data_array = []
    $('.MyCheckBox:checked').each ->
      data_array.push $(this).val()
      return
    data_array

  checked_advisor_discussed = do ->
    data_array = []
    $('.MyCheckBoxAdvisorDiscussed:checked').each ->
      data_array.push $(this).val()
      return
    data_array

  checked_advisor_outcomes = do ->
    data_array = []
    $('.MyCheckBoxAdvisorOutcomes:checked').each ->
      data_array.push $(this).val()
      return
    data_array

  checked_study_resources = do ->
    data_array = []
    $('.MyCheckBoxStudyResources:checked').each ->
      data_array.push $(this).val()
      return
    data_array

  if $(e.target).attr('data-goalId')
    objectId = $(e.target).attr('data-goalId')
    controller = "goals"
    data = { g_status: newStatus, description:  updatedDesc}
  else
    objectId = $(e.target).attr('data-meetingId')
    controller = "meetings"
    data = { m_status: newStatus, notes: updatedNotes, advisor_notes: updatedAdvisorNotes, subject: checked_subjects, advisor_type: updatedAdvisorType, \
            advisor_discussed: checked_advisor_discussed, advisor_outcomes: checked_advisor_outcomes, study_resources: checked_study_resources, \
            career_discussed_other: updatedCareerDiscussedOther, \
            career_outcomes_other: updatedCareerOutcomesOther, \
            academic_discussed_other: updatedAcademicOutcomesOther, \
            academic_outcomes_other: updatedAcademicOutcomesOther, \
            study_resources_other: updatedStudyResourcesOther }
  #alert("meetingId: " + objectId + " m_status:" + newStatus)
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
    alert("Successfully saved!")
    disable_input_fields()

  ).fail((e, request) ->
    alert("error: " + JSON.stringify(e))
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

  $('#main_appointments_table').dataTable language: searchPlaceholder: 'FirstName or LastName'

  toggler = document.getElementsByClassName('caret')
  i = undefined
  i = 0
  while i < toggler.length
    toggler[i].addEventListener 'click', ->
      @parentElement.querySelector('.nested').classList.toggle 'active'
      @classList.toggle 'caret-down'
      return
    i++

  disable_input_fields()
  ua = window.navigator.userAgent;
  is_ie = /MSIE|Trident/.test(ua);
  if ( is_ie )
    $("#coaching_goal_target_date").attr("placeholder", "YYYY/MM/DD")
    $("#coaching_meeting_date").attr("placeholder", "YYYY/MM/DD")
    $("#coaching_goal_target_date").attr('title', 'For IE browser, please use date formate YYYY/MM/DD.')
    $("#coaching_meeting_date").attr('title', 'For IE Browser, pelase use date format YYYY/MM/DD.')

  $('a[data-toggle="tab"]').on 'show.bs.tab', (e) ->
    localStorage.setItem 'activeTab', $(e.target).attr('href')
    return
  activeTab = localStorage.getItem('activeTab')
  if activeTab
    console.log ("activeTab: " + activeTab)
    $('#myTab a[href="' + activeTab + '"]').tab 'show'

  $('.panel-collapse').on 'show.bs.collapse', ->
    $(this).siblings('.panel-heading').addClass 'active'
    return
  $('.panel-collapse').on 'hide.bs.collapse', ->
    $(this).siblings('.panel-heading').removeClass 'active'
    return

  return
