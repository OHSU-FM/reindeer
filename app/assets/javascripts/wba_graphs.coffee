$(document).ready ->

  #$(document).on 'change', '#permission_group_id select', ->
  $('#user_id').on 'change', (e) ->
    user_id = $(this).val()
    console.log("inside wba_graphs --> user_id: " + user_id)
    $.ajax
      url: '/wba_graphs/get_entrustment_data'
      method: 'GET'
      dataType: 'script'
      data: user_id: user_id
      error: (xhr, status, error) ->
        console.error 'AJAX Error: ' + status + error
        return
      success: (response) ->
        #console.log('response: ' + response)

    return
