$ ->
  $('#coaching_meeting_advisor_type').change ->
    advisorType = @value
    #alert advisorType
    $('#coaching_meeting_advisor_id').empty()
    $('div[data-advisors]' ).each ->
      advisors = $(this).data('advisors')
      for key of advisors
        if advisors.hasOwnProperty(key)
          #alert advisors[key].name
          if advisors[key].advisor_type == advisorType
            $('#coaching_meeting_advisor_id').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name + ' - ' + advisors[key].specialty)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
    $('#coaching_meeting_advisor_id').val('')
  return


wellnessPrimary = [
  "Wellness Visit"
]

academicPrimary = [
  "Goal Setting/Updated IPAS"
  "General Learning/Study Strategies"
  "General Assessment/Test-Taking Strategies"
  "Remediation Support"
  "Time Management During Blocks/Rotations"
  "NBME exams – Comp 4 or Clinical Self-Assessments"
  "USMLE – Step 1"
  "USMLE - Step 2 CK"
  "Clinical Skill Assessments – CSAs, OSCEs, CPX"
  "Other"
]

careerPrimary = [
  "Goal Setting/Updated IPPS",
  "General Career Advising/Specialty Exploration/Which Specialty Is Right for Me?"
  "Electives/Rotation Scheduling Advising"
  "Residency Application (ERAS) General Advice"
  "Residency Application - Personal Statement Advice"
  "Residency Application - Letters of Recommendation Advice"
  "Residency Application – Selecting GME Programs to Apply To"
  "Residency Application – Interviewing Tips/Best Practices"
  "Residency Application – Completing My Rank Order List"
  'Residency Application – SOAP Advice ("I’m worried I won’t Match" or "I didn’t initially Match")'
  'Transition to Residency – "Now that I’ve matched, advice for next steps before Residency'
  'Alternate Careers Advising – "After graduation, what options besides GME can I explore?"'
]

$(document).ready ->
  console.log("Inside Meetings Coffee!")
  $('#newMeetingModal').on 'shown.bs.modal', ->
    $('#startDate1').focus()
    return

  advisorType = $(".advisors-type").data("advisor_type")
  console.log("advisor_type: " + advisorType)
  if advisorType == 'Academic'
    data = academicPrimary
  else if advisorType == 'Wellness'
    data = wellnessPrimary
  else
    data = careerPrimary
  nbsp = '&nbsp'
  $('#coaching_meeting_subjects').empty()
  $.each data, (index) ->
    $('#coaching_meeting_subjects').append '<label><input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '</label><br/>'
    return

  FoundSADean = false
  $('#StudentAffairsDean').hide()
  $('#WellnessAdvisor').hide()
  $('#newMeetingModal').draggable handle: '.modal-header'

  $('#coaching_meeting_advisor_type').change ->
    advisorType = $('#coaching_meeting_advisor_type').val()
    #alert("advisor_type: " + advisorType)
    if advisorType == 'Academic'
      data = academicPrimary
    else if advisorType == 'Wellness'
      data = wellnessPrimary
    else
      data = careerPrimary
    nbsp = '&nbsp'
    $('#coaching_meeting_subjects').empty()
    $.each data, (index) ->
      $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
      return

    #$('#EventsTable tr').hide()
  # $("#filtered_by_days").find("option").css("color", "#337ab7")
  # $("#filtered_by_days").change ->
  $('#EventsTable').hide()
  $('#coaching_meeting_advisor_id').change ->
    $('#EventsTable').show()
    # selectedFilteredValue = $('#filtered_by_days option:selected').val()
    # console.log('selectedFilteredValue: ' + selectedFilteredValue)
    advisor_name = $('#coaching_meeting_advisor_id option:selected').text()
    #alert('advisor_name: ' + advisor_name)
    if advisor_name.includes("Benjamin") or advisor_name.includes("Cantone")
      $('#StudentAffairsDean').show()
      $('#WellnessAdvisor').hide()
      $('#AppointmentCard').hide()
      $('#OtherCard').hide()
      $("#meeting-submit").prop("disabled", true);
      FoundSADean = true
      return
    else if advisor_name.includes("Furnari")
        $('#WellnessAdvisor').show()
        $('#StudentAffairsDean').hide()
        $('#AppointmentCard').hide()
        $('#OtherCard').hide()
        $("#meeting-submit").prop("disabled", true);
        FoundSADean = true
        return
    else
      $('#StudentAffairsDean').hide()
      $('#WellnessAdvisor').hide()
      $('#AppointmentCard').show()
      $('#OtherCard').show()
      FoundSADean = false

    selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text().split(" - ")
    modDate = Date.today().addDays(1)
    dataset = $('#EventsTable tbody').find('tr')
    dataset.show()
    # filter the rows that should be hidden
    dataset.each ->
      row = $(this)
      colAdvisor = row.find('td').eq(1).text().split(" - ")
      colDate = row.find('td').eq(2).text().split(" - ")
      #show all rows by default
      #show = true
      row.show()
      #if from date is valid and row date is less than from date, hide the row
      newDate = new Date(modDate)
      orgDate = new Date(colDate[0])

      if (newDate < orgDate) && (colAdvisor[1] == selectedAdvisorText[0])
        row.show()
      else
        row.hide()

      tr_length = $('#EventsTable tbody tr:visible').length
      if (tr_length == 0)
        $("#meeting-submit").prop("disabled", true)
        alert('Please select another advisor that has appointments!!')
      else
        $("#meeting-submit").prop("disabled", false)
      return
