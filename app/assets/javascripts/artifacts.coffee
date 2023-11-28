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
  else if category_code == "Progress Board"
          cat_array = []
          cat_array.push {id: "Progress Board Letter", value: "Progress Board Letter"}
          cat_array.push {id: "Other", value: "Other"}
  else if category_code == "Grade Dispute"
            cat_array = []
            cat_array.push {id: "Grade Dispute", value: "Grade Dispute"}
  else if category_code == "MSPE"
            cat_array = []
            cat_array.push {id: "MSPE Draft", value: "MSPE Draft"}
            cat_array.push {id: "MSPE Final", value: "MSPE Final"}
            cat_array.push {id: "MSPE Supplement", value: "MSPE Supplement"}
  else if category_code == "NBME"
            cat_array = []
            cat_array.push {id: "HSS", value: "HSS"}
  else if category_code == "OASIS Documents"
            cat_array = []
            cat_array.push {id: "IPAS", value: "IPAS"}
            cat_array.push {id: "IPPS", value: "IPPS"}
  else if category_code == "Preceptorship Contract"
            cat_array = []
            cat_array.push {id: "Contract 1", value: "Contract 1"}
            cat_array.push {id: "Contract 2", value: "Contract 2"}
            cat_array.push {id: "Contract 3", value: "Contract 3"}
  else if category_code == "Exemplary Professionalism"
            cat_array = []
            cat_array.push {id: "Exemp-Prof", value: "Exemplary Professionalism"}
  else if category_code == 'Scholarly Project'
          cat_array = []
          cat_array.push {id: "Proposal", value: "Proposal"}
          cat_array.push {id: "Capstone", value: "Capstone"}
          cat_array.push {id: "Final Report", value: "Final Report"}
          cat_array.push {id: "Other", value: "Other"}
  else if category_code == "TTR"
          cat_array = []
          cat_array.push {id: "TTR-OSCE", value: "Transition to Residency - OSCE"}
  else if category_code == "Preceptor Evals"
          cat_array = []
          cat_array.push {id: "Preceptor Eval Text File", value: "Preceptor Eval Text File"}
  else if category_code == "Formative Feedback"
          cat_array = []
          cat_array.push {id: "Formative Feedback Text File", value: "Formative Feedback Text File"}

  else if category_code == "FoM Grades"
          cat_array = []
          cat_array.push {id: "FoM Tab Delimited File", value: "FoM Tab Delimited File"}
  else if category_code == "Competency"
          cat_array = []
          cat_array.push {id: "Competency-Excel", value: "Excel-xlsx"}
  else if category_code == "BLS"
            cat_array = []
            cat_array.push {id: "BLS-Excel", value: "Excel-xlsx"}
    else if category_code == "EG Cohorts"
              cat_array = []
              cat_array.push {id: "EG-Cohorts", value: "EG Cohorts (Tab Delimited)"}
  else if category_code == "Other"
          cat_array = []
          cat_array.push {id: "Misc", value: "Misc"}
        else
          console.log("else logic --> category_code: " + category_code)
          return []
  return cat_array

window.main_comp = ['comp1', 'comp2a', 'comp2b', 'comp3', 'comp4', 'comp5a', 'comp5b', 'labels' ]
window.block_codes = ['1-FUND', '2-BLHD', '3-SBM', '4-CPR', '5-HODI', '6-NSF', '7-DEVH']
$(document).ready ->
  $('#artifact_title').on 'change', (e) ->
    catCode = $(this).val()
    $('#artifact_content').empty()
    console.log ("artifact_title: " + catCode)
    data = epa_codes(catCode)
    $.each data, (key, entry) ->
      $('#artifact_content').append $('<option></option>').attr('value', entry.id).text(entry.value)
      return

  #$(document).on 'change', '#permission_group_id select', ->
  $('#permission_group_id').on 'change', (e) ->
    queryString = window.location.search
    urlParams = new URLSearchParams(queryString)
    file_type = urlParams.get('file_type')
    console.log 'file_type: ' + file_type

    permission_group_id = $(this).val()
    console.log("permission_group_id: " + permission_group_id)
    $.ajax
      url: '/artifacts/new?file_type=' + file_type
      method: 'GET'
      dataType: 'json'
      data: permission_group_id: permission_group_id
      error: (xhr, status, error) ->
        console.error 'AJAX Error: ' + status + error
        return
      success: (response) ->
        #console.log response
        if (file_type == 'Regular')
          cohort_students = response['cohort_students']
          $('#user_id').empty()
          $('#user_id').append '<option>Select Student</option>'
          i = 0
          while i < cohort_students.length
            $('#user_id').append '<option value="' + cohort_students[i]['id'] + '">' + cohort_students[i]['full_name'] + '</option>'
            i++
        else if (file_type == 'FoM')
            course_codes = response['course_codes']
            $('#course_code').empty()
            $('#course_code').append '<option>Select a Course Code</option>'
            i = 0
            while i < course_codes.length
              $('#course_code').append '<option value="' + course_codes[i] + '">' + course_codes[i] + '</option>'
              i++

        return

    $('#artifact_title').on 'change', (e) ->
    catCode = $(this).val()
    $('#artifact_content').empty()
    console.log ("artifact_title: " + catCode)
    data = epa_codes(catCode)
    $.each data, (key, entry) ->
      $('#artifact_content').append $('<option></option>').attr('value', entry.id).text(entry.value)
      return


    $('#course_code').on 'change', (e) ->
      course_code_val = $('#course_code').val()
      console.log ("course_code: " + course_code_val)
      console.log ("course codes OPTION length: " + $('#course_code option').length)
      if course_code_val == 'New Block'
        $('#artifact_title').empty()
        i = 0
        while i < window.block_codes.length
          $('#artifact_title').append '<option value="' + window.block_codes[i] + '">' + window.block_codes[i] + '</option>'
          i++
        $('#artifact_content').empty()
        $('#artifact_content').append '<option value="labels">' + 'labels' + '</option>'
        return
      else
        $('#artifact_title').empty()
        i = 0
        while i < window.main_comp.length
          $('#artifact_title').append '<option value="' + window.main_comp[i] + '">' + window.main_comp[i] + '</option>'
          i++
        return
      return

    $('#component').on 'change', (e) ->
      component = $(this).val()
      permission_group_id = $('#permission_group_id').val()
      course_code = $('#course_code').val()
      if component == 'labels'
        $('#artifact_content').empty()
        $('#artifact_content').append '<option>labels</option>'
        return
      console.log 'course_code: ' + course_code
      $.ajax
        url: '/artifacts/get_sub_components'
        method: 'get'
        dataType: 'json'
        data: {permission_group_id: permission_group_id, course_code: course_code, component: component}
        error: (xhr, status, error) ->
          console.error 'AJAX Error: ' + status + error
          return
        success: (response) ->
          console.log response
          window.sub_comps = response['sub_components']
          $('#artifact_content').empty()
          $('#artifact_content').append '<option>Select a sub-component</option>'
          i = 0
          while i < window.sub_comps.length
            $('#artifact_content').append '<option value="' + window.sub_comps[i][0] + '">' + window.sub_comps[i][1] + '</option>'
            i++
          return

    # $('#artifact_title').on 'change', (e) ->
    #   component = $(this).val()
    #   console.log 'component: ' + component
    #   $('#artifact_content').empty()
    #   $('#artifact_content').append '<option>Select a sub-component</option>'
    #   i = 0
    #   while i < window.sub_comps.length
    #     if (window.sub_comps[i][0].includes(component))
    #       if (!(window.sub_comps[i][0].includes('avg')) || (window.sub_comps[i][0].includes('summary_')))
    #         $('#artifact_content').append '<option value="' + window.sub_comps[i][0] + '">' + window.sub_comps[i][1] + '</option>'
    #     i++
    #   return
