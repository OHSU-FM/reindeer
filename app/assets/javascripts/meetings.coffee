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


studyResources = [
      ["Live Lecture"],
      ["Recorded OHSU Lecture"],
      ["Textbook"],
      ["Anki"],
      ["Boards & Beyond"],
      ["Pathoma"],
      ["NBME Questions"],
      ["UWORLD/other board prep questions"],
      ["Other (text box)"]
]

wellnessPrimary = [
  "Wellness Visit"
]

diversityNavigatorPrimary = [
  "General"
  "Scholarship Meeting"
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
  "General Career Advising/Specialty Exploration/Which Specialty Is Right for Me?",
  "Electives/Rotation Scheduling Advising",
  "Residency Application (ERAS) General Advice",
  "Residency Application - Personal Statement Advice",
  "Residency Application - Letters of Recommendation Advice",
  "Residency Application – Selecting GME Programs to Apply To",
  "Residency Application – Interviewing Tips/Best Practices",
  "Residency Application – Completing My Rank Order List",
  'Residency Application – SOAP Advice ("I’m worried I won’t Match" or "I didn’t initially Match")',
  'Transition to Residency – "Now that I’ve matched, advice for next steps before Residency',
  'Alternate Careers Advising – "After graduation, what options besides GME can I explore?"',
  'Scholarship Approval'
]

$(document).ready ->
  console.log("Inside Meetings Coffee!")

  $('#meeting-submit').click ->
    if ($('input[name^="coaching_meeting[subject][]"]:checked').length == 0)
      alert("You must check at least one Primary Reasons!")  
      return
      #$("#meeting-submit").prop("disabled", true)


  #$("#advisor_id").prepend('<option selected="selected" value="All"> All Advisors </option>');
  $("#advisor_id option").eq(1).after($("<option></option>").val("All").text("All Advisors"));

  $("#coaching_meeting_study_resources_other_text_box").change ->
    if $(this).prop('checked')
      $("#coaching_meeting_study_resources_other").prop("disabled", false)
    else
      $("#coaching_meeting_study_resources_other").prop("disabled", true)
    return

  #$("#coaching_meeting_study_resources_other_text_box").change ->

  if $("#meeting_study_resources_other_text_box").prop('checked')
    $("#study_resources_other").prop("disabled", false)
  else
    $("#study_resources_other").prop("disabled", true)
  #return

  $('#newMeetingModal').on 'shown.bs.modal', ->
    $('#startDate1').focus()
    return

  advisorType = $(".advisors-type").data("advisor_type")
  console.log("advisor_type: " + advisorType)
  if advisorType == 'Academic'
    data = academicPrimary
  else if advisorType == 'Wellness'
    data = wellnessPrimary
  else if advisorType == 'Diversity Navigator'
    data = diversityNavigatorPrimary
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
      # to hide study Resources
      $('#study_resources').show()
    else if advisorType == 'Wellness'
      data = wellnessPrimary
      $('#study_resources').hide()
    else if advisorType == 'Diversity Navigator'
      data = diversityNavigatorPrimary
      $('#study_resources').hide()
    else
      data = careerPrimary
      $('#study_resources').hide()

    nbsp = '&nbsp'
    $('#coaching_meeting_subjects').empty()
    $.each data, (index) ->
      $('#coaching_meeting_subjects').append '<label><input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '</label><br/>'
      return

    # $('#study_resources').empty()
    # $.each data_study, (index) ->
    #   $('#study_resources').append '<label><input type=\'checkbox\' name=\'coaching_meeting[study_resources][]\' value=\'' + data_study[index] + '\' />' + nbsp + data_study[index] + '</label><br/>'
    #   return


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

    rowCount = $("#EventsTable tr").not('thead tr').length;
    console.log('rowCount: ' + rowCount)

    if (rowCount == 0)
      $("#meeting-submit").prop("disabled", true)
      alert('No Appointment Found! Please select another advisor that has appointments!!')
      return
      #dataset.show()
      # filter the rows that should be hidden
    tr_length = 0
    dataset = $('#EventsTable tbody').find('tr')
    dataset.each ->
      row = $(this)
      colAdvisor = row.find('td').eq(1).text().split(" - ")
      colDate = row.find('td').eq(2).text().split(" - ")
      #show all rows by default
      #show = true
      #row.show()
      #if from date is valid and row date is less than from date, hide the row
      newDate = new Date(modDate)
      orgDate = new Date(colDate[0])

      #console.log('selectedAdvisorText: ' + selectedAdvisorText[0] + ' --> colAdvisor: ' + colAdvisor[1])
      if (colAdvisor[1] == selectedAdvisorText[0])
        row.show()
      else
        row.hide()

    tr_length = $('#EventsTable tbody tr:visible').length
      #console.log ("tr_length: " + tr_length)
    console.log("tr_length: " + tr_length)
    if (tr_length == 0)
      $("#meeting-submit").prop("disabled", true)
      alert('Please select another advisor that has appointments!!')
      #return false
    else
      $("#meeting-submit").prop("disabled", false)
    return
