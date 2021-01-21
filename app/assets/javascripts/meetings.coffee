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
            $('#coaching_meeting_advisor_id').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
  return

ipas = [
  "Peer Tutoring"
  "Provost’s Student Learning Support Specialist"
  "Student Health & Wellness Center"
  "Office of Student Access / Explore accommodations"
  "Financial / Debt Mgr"
  "UME curricular leader (block, thread, course, or clinical experience director)"
  "Other OASIS advisor"
  "UME Student Affairs"
  "Other (text box)"
]

ipps = [
  "Dept-based Residency Specialty Advisor connection"
  "Online resources explored / encouraged (Careers in Med, Sakai, etc)"
  "Student Health & Wellness Center"
  "Office of Student Access / Explore accommodations"
  "Financial / Debt Mgr"
  "UME curricular leader (course or clinical experience director)"
  "Other OASIS advisor"
  "UME Student Affairs"
  "Other (text box)"
]

$ ->
  $('#coaching_meeting_advice_category').change ->
    adviceCategory = @value
    #alert adviceCategory
    if adviceCategory == 'IPAS'
      data = ipas
    else
      data = ipps
    # I'm expecting your data will be similar to this
    nbsp = '&nbsp'
    $('#coaching_meeting_subjects').empty()
    $.each data, (index) ->
      $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
      return
  return

$ ->
  $('#coaching_meeting_advisor_type').change ->
  advisorType = @value

  if advisorType == 'Career'
    data = ipps
  else
    data = ipas
  nbsp = '&nbsp'
  $('#coaching_meeting_subjects').empty()
  $.each data, (index) ->
    $('#coaching_meeting_subjects').append '<input type=\'checkbox\' name=\'coaching_meeting[subject][]\' value=\'' + data[index] + '\' />' + nbsp + data[index] + '<br/>'
    return
return

$(document).ready ->
  console.log("Inside Meetings Coffee!")
