# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#rankingDataTable').dataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
  oTable = $('#rankingDataTable').dataTable()
  oTable.fnSort([9, 'desc'])  # sorting the average column on the table

  $('.button').click ->
    # $('#competencyForm').attr('onsubmit','return true;')
    cohortChecked = [];
    $('input:checked.form-check-input').each ->
      cohortChecked.push $(this).val()
      return
    console.log("checked cohort: " + JSON.stringify(cohortChecked))

    $.ajax
      url: '/reports/competency'
      type: 'get'
      data: {cohortChecked: JSON.stringify(cohortChecked)}
      dataType: 'script'
      success: (data) ->
        # alert 'Ajax called Success!'
        return
      error: (request, error) ->
        alert 'Request: ' + JSON.stringify(request)
        return

  $('#competencyForm').attr('onsubmit','return false;')
