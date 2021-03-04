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
  $("#meeting-submit").prop("disabled", true);
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
      selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text().split(" - ")
          #
      dataset = $('#EventsTable tbody').find('tr')
      # show all rows first
      modDate = Date.today().addDays(0)
      dataset.show()
      # filter the rows that should be hidden
      dataset.each ->
        row = $(this)
        colAdvisor = row.find('td').eq(1).text().split(" - ")
        colDate = row.find('td').eq(2).text().split(" - ")
        #show all rows by default
        show = true
        #if from date is valid and row date is less than from date, hide the row
        newDate = new Date(modDate)
        orgDate = new Date(colDate[0])
        if  (newDate < orgDate) && (colAdvisor[1] == selectedAdvisorText[0])
          #console.log("modDate: " + modDate + "  table date: " + colDate[0])
          show = true
        else
          show = false

        if show
          row.show()
        else
          row.hide()
        return


      tr_length = $('#EventsTable tbody tr:visible').length
      if tr_length == 0
        $("#meeting-submit").prop("disabled", true);
        alert('Please select another advisor!!')
      else
        $("#meeting-submit").prop("disabled", false);
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

    $('#EventsTable tr').hide()
    $("#filtered_by_days").find("option").css("color", "#337ab7")
    $("#filtered_by_days").change ->
      $('#EventsTable').show()
      selectedFilteredValue = $('#filtered_by_days option:selected').val()
      console.log('selectedFilteredValue: ' + selectedFilteredValue)
      selectedAdvisorText = $("#coaching_meeting_advisor_id option:selected" ).text().split(" - ")
      modDate = Date.today().addDays(selectedFilteredValue)
      dataset = $('#EventsTable tbody').find('tr')
      dataset.show()
      # filter the rows that should be hidden
      dataset.each ->
        row = $(this)
        colAdvisor = row.find('td').eq(1).text().split(" - ")
        colDate = row.find('td').eq(2).text().split(" - ")
        #show all rows by default
        show = true
        #if from date is valid and row date is less than from date, hide the row
        newDate = new Date(modDate)
        orgDate = new Date(colDate[0])
        if  (newDate < orgDate) && (colAdvisor[1] == selectedAdvisorText[0])
          #console.log("modDate: " + modDate + "  table date: " + colDate[0])
          show = true
        else
          show = false

        if show
          row.show()
        else
          row.hide()
        return
