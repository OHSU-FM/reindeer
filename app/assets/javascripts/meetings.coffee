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

$(document).ready ->
  console.log("Inside Meetings Coffee!")
  $('#newMeetingModal').draggable handle: '.modal-header'
  $ ->
    # $('#coaching_meeting_advisor_id').change ->
    #   selectedAdvisorType = $('#coaching_meeting_advisor_type option:selected').val()
    #   selectedAdvisorId = $('#coaching_meeting_advisor_id option:selected').val()
    #   selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text()
    #   alert("selectedAdvisorId & Type: " + selectedAdvisorId + " - " + selectedAdvisorType )
    $('#EventsTable tr').hide()
    $('#coaching_meeting_advisor_id').change ->
      $('#EventsTable').show()
      selectedAdvisorType = $('#coaching_meeting_advisor_type option:selected').val()
      selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text()
      selection = selectedAdvisorText   #selectedAdvisorType + " Advisor - " + selectedAdvisorText
      #
      dataset = $('#EventsTable tbody').find('tr')
      # show all rows first
      dataset.show()
      # filter the rows that should be hidden
      dataset.filter((index, item) ->
        $(item).find('td:nth-child(2)').text().indexOf(selection) == -1  # find in 2nd col
      ).hide()
      return

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

    $('#coaching_meeting_advisor_type').change ->
      advisorType = $('#coaching_meeting_advisor_type').val()
      #alert("advisor_type: " + advisorType)
      if advisorType == 'Academic'
        data = academicPrimary
      else
        data = careerPrimary
      nbsp = '&nbsp'
      $('#coaching_meeting_subjects').empty()
      $.each data, (index) ->
        $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
        return


# ipas = [
#   "Peer Tutoring"
#   "Provost’s Student Learning Support Specialist"
#   "Student Health & Wellness Center"
#   "Office of Student Access / Explore accommodations"
#   "Financial / Debt Mgr"
#   "UME curricular leader (block, thread, course, or clinical experience director)"
#   "Other OASIS advisor"
#   "UME Student Affairs"
#   "Other (text box)"
# ]
#
# ipps = [
#   "Dept-based Residency Specialty Advisor connection"
#   "Online resources explored / encouraged (Careers in Med, Sakai, etc)"
#   "Student Health & Wellness Center"
#   "Office of Student Access / Explore accommodations"
#   "Financial / Debt Mgr"
#   "UME curricular leader (course or clinical experience director)"
#   "Other OASIS advisor"
#   "UME Student Affairs"
#   "Other (text box)"
# ]
#
# $ ->
#   $('#coaching_meeting_advice_category').change ->
#     adviceCategory = @value
#     #alert adviceCategory
#     if adviceCategory == 'IPAS'
#       data = ipas
#     else
#       data = ipps
#     # I'm expecting your data will be similar to this
#     nbsp = '&nbsp'
#     $('#coaching_meeting_subjects').empty()
#     $.each data, (index) ->
#       $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
#       return
#   return
#
# $ ->
#   $('#coaching_meeting_advisor_type').change ->
#   advisorType = @value
#
#   if advisorType == 'Career'
#     data = ipps
#   else
#     data = ipas
#   nbsp = '&nbsp'
#   $('#coaching_meeting_subjects').empty()
#   $.each data, (index) ->
#     $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
#     return
# return


  #radioVal = $("#myform input[type='radio']:checked").val()
