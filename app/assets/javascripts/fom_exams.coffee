# $('#check_all').click(function () {
#     $('input:checkbox').prop('checked', this.checked);
# });
#
# var emails = [];
# $('#SendAlerts').click(function () {
#   $.each($("input[name='checkbox']:checked"), function (K, V) {
#       emails.push(V.value);
#   });
emails = []
$(document).ready ->
  #alert("Inside form_exam.coffee")

  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return

  # $('#SendAlerts').click ->
  #   $.each $('input[name=\'checkbox\']:checked'), (K, V) ->
  #     emails.push V.value
  #     return
  #   return


# $(document).on 'click', '#SendAlerts', ->
#   email_message = []
#   skip_emails = []
#   alert 'button is clicked'
#   #$("input:checkbox:not(:checked)")
#   $.each $("input:checkbox:not(:checked)"), (K, V) ->
#     skip_emails.push {user_id: V.value}
#     return
#
#   email_message.push {skip_email: skip_emails}
#
#   from = $("#from").val()
#   email_message.push {from: from}
#
#   body_message = $("#body_message").val()
#   email_message.push {body_message: body_message}
#
#   $.ajax
#     dataType: 'json'
#     type: 'GET'
#     url: '/fom_exams/send_alerts'
#     data: email_message:  JSON.stringify(email_message)
#     success: (data) ->
#       alert 'All Emails are Collected!'
#       return
#     error: (request, error) ->
#       alert 'Request Reviews: ' + JSON.stringify(request)
#       return
#
#   return
