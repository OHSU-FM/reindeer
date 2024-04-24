$ ->
  $('#coaching_meeting_advisor_type').change ->
    advisorType = @value
    #alert advisorType
    $('#coaching_meeting_advisor_id').empty()
    $('#coaching_meeting_advisor_id').append $('<option></option').attr('value', '').text('Please Choose Your Option')
    $('div[data-advisors]' ).each ->
      advisors = $(this).data('advisors')
      for key of advisors
        if advisors.hasOwnProperty(key)
          #alert advisors[key].name + ' --> ' + advisors[key].advisor_type
          if advisorType.includes("Step 1") or advisorType.includes("Remediation")
            if advisors[key].advisor_type.includes("Academic")
              $('#coaching_meeting_advisor_id').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name + ' - ' + advisors[key].specialty)
          else if advisors[key].advisor_type.includes(advisorType)
            $('#coaching_meeting_advisor_id').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name + ' - ' + advisors[key].specialty)

      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
    #$('#coaching_meeting_advisor_id').val('')
  return


studyResources = [
      ["Live Lecture"],
      ["Recorded OHSU Lecture"],
      ["Textbook"],
      ["First Aide to Step 1"],
      ["Sketchy"],
      ["Anki"],
      ["Boards & Beyond"],
      ["Pathoma"],
      ["NBME Questions"],
      ["Amboss Q Bank"],
      ["UWORLD Qbank/other board prep questions"],
      ["Other (text box)"]
]

step1Resources = [
  ["First Aide to Step 1"],
  ["Sketchy"],
  ["Anki"],
  ["Pathoma"],
  ["Boards and Beyond"],
  ["Uworld Qbank"],
  ["Amboss Q Bank"],
  ["Other (text box)"]
]

wellnessPrimary = [
  "Wellness Visit"
]
diversityNavigatorPrimary = [
  "General"
  "Scholarship Meeting"
]

assistDeanPrimary = [
  "General Vist"
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

academicStep1Primary = [
  "USMLE – Step 1"
]
remediationPrimary = [
  "Remediation Support"
]

careerPrimary = [
  "WBA Guidance",
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
  'Scholarship Approval',
]
window.ajaxStatus = ""  #global var
window.eventIdGlobal = ""
checkEvent = (event_id) ->
  $.ajax
    async: false  #tell the browser to finish the ajax call
    type: 'GET'
    url: '/events/check_events'
    dataType: 'json'
    data: event_id: event_id
    success: (response) ->
      console.log 'success response: ' + JSON.stringify(response)
      console.log ("Status : " + response.Status)
      return response.Status
    error: (response) ->
      alert 'Something went WRONG!!'
      return

$(document).on 'change', "input[type='checkbox'][name='coaching_meeting[subject][]']", ->
  if $(this).is(':checked')
    #alert '${this.value} is checked'
    $("#meeting-submit").prop("disabled", false)
    return
  else
    # do what you need here
    $("#meeting-submit").prop("disabled", true)
  return

check_events_deans = () ->
  $('#EventsTable td:nth-child(2)').each ->
    #console.log ("this: "  + $(this).text())
    if $(this).text().includes("Cantone")
      if $(this).text().includes("Step Delay")
        $(this).parent('tr').css 'background-color', '#E37383'
      else
        $(this).parent('tr').css 'background-color', '#90EE90'
    else if $(this).text().includes("Schneider")
      if $(this).text().includes("Step Delay")
        $(this).parent('tr').css 'background-color', '#E0b0FF'
      else
        $(this).parent('tr').css 'background-color', '#B7E9F7'
    return
#==================================================================================================================
modalHtml = "" #this is varibale, in which we will save modal html before open

$(document).ready ->
  console.log("Inside Meetings Coffee!")

  $('#coaching_meeting_advisor_type').change ->
    $("#All-Events").empty();
    return

  $('#coaching_meeting_advisor_id').change ->
    advisorID = this.value
    advisorType = $('#coaching_meeting_advisor_type').val()
    console.log ("advisorID: " + advisorID)
    $.ajax
      url: '/events/get_events_by_advisor'
      type: 'get'
      data: {advisor_id: advisorID, advisor_type: advisorType}
      dataType: 'script'
      success: (data) ->
        # alert 'Ajax called Success!'
        return
      error: (request, error) ->
        alert 'Request: ' + JSON.stringify(request)
        return
    return


  $('#IndividualAdvisorRpt').dataTable language: searchPlaceholder: 'FirstName or LastName'
  $("#meeting-submit").prop("disabled", true)

  $('#EventsTable').hide()
  $('#show_all_events').click ->
    $('#EventsTable td:nth-child(2)').each ->
      dataset = $('#EventsTable tbody').find('tr')
      dataset.each ->
        row = $(this)
        row.show()
    return
  #$('#EventsTable').DataTable()
  #-- Disabled the code below as it causes subtle errors on 9/9/2022
  # it supposed to prevent duplicate appointment

  $('#meeting-submit').click (event) ->
    event_id = $('input:radio:checked').val()
    eventIdGlobal = event_id
    ajaxStatus = checkEvent(event_id)  #async: false  #tell the browser to finish the ajax call
    if ajaxStatus.responseJSON.Status.includes('AVAILABLE')
      return
    $('#coaching_meeting_event_id_' + event_id).addClass("disabled-color");
    $('#coaching_meeting_event_id_' + event_id).prop('checked', false).button("refresh").prop('disabled', true)
    alert("The Appointment is NOT AVAILABLE, please select another one!")
    event.preventDefault()
    return

  $("input[type='radio'][name='coaching_meeting[event_id]'").change ->
    event_id = $('input:radio:checked').val()
    eventIdGlobal = event_id

    ajaxStatus = checkEvent(event_id)  #async: false  #tell the browser to finish the ajax call
    console.log ('First Check when radio is clicked: ' + JSON.stringify(ajaxStatus.responseJSON))
    if ajaxStatus.responseJSON.Status.includes('AVAILABLE')
      # the codes below need to be kept..
      advisorType = $("#advisor-" + @value).data('advisor-type')
      console.log("advisorType: " + advisorType)
      $("#coaching_meeting_advisor_type").val(advisorType).trigger("chosen:updated")
      advisorID = $("#advisor-" + @value).data('advisor-' + @value)
      $("#coaching_meeting_advisor_id").val(advisorID).trigger("chosen:updated")
      return
    else
      $('#coaching_meeting_event_id_' + event_id).addClass("disabled-color");
      $('#coaching_meeting_event_id_' + event_id).prop('checked', false).button("refresh").prop('disabled', true)
      alert("The Appointment is NOT AVAILABLE, please select another one!")
      return

    # if ($('input[name^="coaching_meeting[subject][]"]:checked').length == 0)
    #     $("#meeting-submit").prop("disabled", true)
    #     alert("You must check at least one Primary Reasons!")
    #     return false

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
    dataResources = studyResources
  else if advisorType == 'Academic: Step 1 Advising'
    data = academicStep1Primary
    dataResources = step1Resources
  else if advisorType == 'Academic: Remediation Support'
    data = remediationPrimary
  else if advisorType == 'Career'
    data = careerPrimary
  else if advisorType == 'Wellness'
    data = wellnessPrimary
  else if advisorType == 'Diversity Navigator'
    data = diversityNavigatorPrimary
  else if advisorType == 'Assist Dean'
    data = assistDeanPrimary
  else
    data = academicPrimary

  nbsp = '&nbsp'
  $('#coaching_meeting_subjects').empty()
  $.each data, (index) ->
    $('#coaching_meeting_subjects').append '<label for="MeetingSubjects"><input type=\'checkbox\' class=\'primaryCheckbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '</label><br/>'
    return
  # $('#study_resources').empty()
  # $.each dataResources, (index) ->
  #   $('#study_resources').append '<label><input type=\'checkbox\' class=\'primaryCheckbox\' name=\'coaching_meeting[subject][]\' value=\'' + dataResources[index] + '\' />' + nbsp + dataResources[index] + '</label><br/>'
  #   return


  FoundSADean = false
  $('#StudentAffairsDean').hide()
  $('#WellnessAdvisor').hide()
  $('#newMeetingModal').draggable handle: '.modal-header'

  $('#coaching_meeting_advisor_type').change ->
    advisorType = $('#coaching_meeting_advisor_type').val()
    #alert("advisor_type: " + advisorType)
    if advisorType == 'Academic'
      data = academicPrimary
      $('#study_resources').show()
      $('#practice_test_scores').hide()
    else if advisorType == 'Academic: Step 1 Advising'
      data = academicStep1Primary
      $('#study_resources').show()
      $('#practice_test_scores').show()
    else if advisorType == 'Academic: Remediation Support'
      data = remediationPrimary
      $('#study_resources').show()
      $('#practice_test_scores').hide()
    else if advisorType == 'Wellness'
      data = wellnessPrimary
      $('#study_resources').hide()
      $('#practice_test_scores').hide()
    else if advisorType == 'Diversity Navigator'
      data = diversityNavigatorPrimary
      $('#study_resources').hide()
      $('#practice_test_scores').hide()
    else if advisorType == 'Assist Dean'
      data = assistDeanPrimary
      $('#study_resources').hide()
      $('#practice_test_scores').hide()
    else
      data = careerPrimary
      $('#study_resources').hide()
      $('#practice_test_scores').hide()

    nbsp = '&nbsp'
    $('#coaching_meeting_subjects').empty()
    $.each data, (index) ->
      $('#coaching_meeting_subjects').append '<label for="MeetingSubjects"><input type=\'checkbox\' class=\'primaryCheckbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '</label><br/>'
      return

  #$('#EventsTable').show()  ## change this on 6/27/2022 to test the datea
  $('#coaching_meeting_advisor_id').change ->
    $('#EventsTable').show()
    # selectedFilteredValue = $('#filtered_by_days option:selected').val()
    # console.log('selectedFilteredValue: ' + selectedFilteredValue)
    advisor_name = $('#coaching_meeting_advisor_id option:selected').text()

    if advisor_name.includes("Furnari")
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

    selectedAdvisorType = $("#coaching_meeting_advisor_type option:selected").text()
    console.log("selectedAdvisorType: " + selectedAdvisorType)
    selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text().split(" - ")
    console.log("selectedAdvisorText: " + selectedAdvisorText[0])


    rowCount = $("#EventsTable tr").not('thead tr').length;
    console.log('rowCount: ' + rowCount)

    # if (rowCount == 0)
    #   $("#meeting-submit").prop("disabled", true)
    #   alert('No Appointment Found! Please select another advisor that has appointments!!')
    #   return


    #dataset.show()
    # filter the rows that should be hidden
    tr_length = 0
    dataset = $('#EventsTable tbody').find('tr')
    modDate = Date.today()
    newDate = new Date(modDate)
    dataset.each ->
      row = $(this)
      colAdvisor = row.find('td').eq(1).text().split(" - ")
    #  console.log("colAdvisor[0]: " + colAdvisor[0] + " colAdvisor[1]: " + colAdvisor[1])
      colDate = row.find('td').eq(2).text().split(" - ")
      row.show()
      found_dean = colAdvisor[0].indexOf("Assist Dean")      #colAdvisor[0] may contain 'Assist Dean'

      if (selectedAdvisorType == "Assist Dean") && (colAdvisor[1] == selectedAdvisorText[0])   #'Cantone, Rebecca' || colAdvisor[1] == 'Schneider, Benjamin')
        row.show()
      else if ((colAdvisor[0].includes('Academic Advisor')) && (selectedAdvisorType == 'Academic') && (colAdvisor[1] == selectedAdvisorText[0]))
        # console.log("** colAdvisor[0]: " + colAdvisor[0])
        # console.log("** selectedAdvisorType: " + selectedAdvisorType)
        row.show()
      else if ((colAdvisor[0].includes('Academic: Step 1')) && (selectedAdvisorType.includes('Step 1')) && (colAdvisor[1] == selectedAdvisorText[0]))
        row.show()
      else if ((colAdvisor[0].includes('Academic: Remediation')) && (selectedAdvisorType.includes('Remediation')) && (colAdvisor[1] == selectedAdvisorText[0]))
        row.show()
      else if ((colAdvisor[0].includes('Career')) && (selectedAdvisorType.includes('Career')) && (colAdvisor[1] == selectedAdvisorText[0]) )
        row.show()
      else if ((colAdvisor[0].includes('Diversity')) && (selectedAdvisorType.includes('Diversity')) && (colAdvisor[1] == selectedAdvisorText[0]))
        row.show()
      else if ((colAdvisor[0].includes('Wellness')) && (selectedAdvisorType.includes('Wellness')) && (colAdvisor[1] == selectedAdvisorText[0]))
        row.show()

      else
        row.hide()

    tr_length = $('#EventsTable tbody tr:visible').length
    console.log("tr_length: " + tr_length)
    if (tr_length == 0)
      $("#meeting-submit").prop("disabled", true)
      # alert('Please select another advisor that has appointments!!')

    else
      #$("#meeting-submit").prop("disabled", false)
    return
