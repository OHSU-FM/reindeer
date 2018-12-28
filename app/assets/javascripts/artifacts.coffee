# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

epa_codes = (category_code) ->
  if category_code == "EPA-Artifacts"
    cat_array = []
    i = 1
    while i <= 13
      cat_array.push {id: "EPA" + i, value: "EPA" + i}
      i++
  else if category_code == 'FoM'
          cat_array = []
          FOM = ["FUND","BLHD", "SBM", "CPR", "HODI", "NSF", "DEVH"]
          i = 0
          while i <= 6
            cat_array.push {id: FOM[i], value: FOM[i]}
            i++
  else if category_code == 'Clinical'
          cat_array = []
          CLINICAL = ["Shelf Exams", "Mock Step 1", "TTCE Packet", "CPX"]
          i = 0
          while i <= 3
            cat_array.push {id: CLINICAL[i], value: CLINICAL[i]}
            i++
  else if category_code == 'Scholarly Project'
          cat_array = []
          cat_array.push {id: "Proposal", value: "Proposal"}
          cat_array.push {id: "Capstone", value: "Capstone"}
        else
          return []

  return cat_array


$(document).ready ->
  $('#artifact_title').on 'change', (e) ->
    catCode = $(this).val()
    $('#artifact_content').empty()
    console.log ("artifact_title: " + catCode)
    data = epa_codes(catCode)
    $.each data, (key, entry) ->
      $('#artifact_content').append $('<option></option>').attr('value', entry.id).text(entry.value)
      return
