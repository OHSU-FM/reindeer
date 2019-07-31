# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  #$(document).on 'change', '#permission_group_id select', ->
  $('#coach_id').on 'change', (e) ->
    coach_id = $(this).val()
    console.log("coach: " + coach_id)
    $.ajax
      url: '/csl_feedbacks/index'
      method: 'GET'
      dataType: 'json'
      data: coach_id: coach_id
      error: (xhr, status, error) ->
        console.error 'AJAX Error: ' + status + error
        return
      success: (response) ->
        console.log response
        cohort_students = response['cohort_students']
        $('#student_id').empty()
        $('#student_id').append '<option>Select Student</option>'
        i = 0
        while i < cohort_students.length
          $('#student_id').append '<option value="' + cohort_students[i]['id'] + '">' + cohort_students[i]['full_name'] + '</option>'
          i++
        return
    return
