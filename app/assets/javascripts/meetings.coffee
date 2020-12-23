$ ->
  $('#coaching_meeting_advisor_type').change ->
    advisorType = @value
    alert advisorType
    $('#coaching_meeting_advisor_id').empty()
    $('div[data-advisors]' ).each ->
      advisors = $(this).data('advisors')
      for key of advisors
        if advisors.hasOwnProperty(key)
          #alert advisors[key].name
          if advisors[key].advisor_type == advisorType
            $('#coaching_meeting_advisor_id').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
  return

$ ->
  $('#coaching_meeting_advice_category').change ->
    adviceCategory = @value
    alert adviceCategory
    $('#coaching_meeting_subjects').empty()
    array_ipps = ["CheckBox1", "CheckBox2", "CheckBox3"]
    $.each array_ipps, ->
      $('#coaching_meeting_subjects').append $('<label>').text(@name).prepend($('<input>').attr('type', 'checkbox').val(@name).prop('checked', @checked))
      return
  return

$(document).ready ->
  console.log("Inside Meetings Coffee!")
