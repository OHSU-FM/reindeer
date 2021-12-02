window.LsReports = {}

window.LsReports.qtypes = {
  dual_arr         : "A question consisting of multiple sub questions. Each one has two 'Select one from a list' parts",
  five_point       : "Select one from 5 Point Choice",
  arr_five         : "Select one from Array (5 Point Choice)",
  arr_ten          : "Select one from Array (10 Point Choice)",
  arr_ynu          : "Select one from Array (Yes/No/Uncertain)",
  date             : "The answers to this question refers to a date",
  arr_isd          : "Select one from Array (Increase, Same, Decrease)",
  arr_flex         : "This question consists of multiple sub questions. One answer is selected from a list of options",
  gender           : "The answers to this question refer to a person's Gender",
  arr_flex_col     : "Select one from Array (Flexible Labels) by Column",
  lang             : "The answers to this question refer to a Language",
  mult_numeric     : "This question consists of multiple sub questions that each refer to a number",
  list_radio       : "Select one from List (Radio)",
  mult             : "Select one or many from List (Checkbox)",
  numeric          : "The answers to this question refers to a number",
  list_comment     : "Select one from List, with option to leave a comment",
  mult_w_comments  : "Select one or many from list and optionally leave comments",
  mult_short_text  : "A question with room for Multiple Short Text responses",
  rank             : "Rank order these options",
  short_text       : "The answers to this question are in a Short Free Text field",
  long_text        : "The answers to this question are in a Long Free Text field",
  huge_text        : "The answers to this question are in a  Huge Free Text field",
  boiler           : "Not a question. This is a portion of the survey that offers additional instructions",
  yes_no           : "Select one answer: Yes/No",
  list_drop        : "Select one from a dropdown list",
  arr_mult_drop    : "Select one or many from Array (Flexible Labels) multiple drop down",
  arr_mult_text    : "Select one or many Array (Flexible Labels) multiple texts",
  file_upload      : "File Upload"
}

$(document).ready ->

  # Refresh page on change
  $('select.select_a_link').change ->
    $('#modal_nav_reports').modal('show');
    console.log ("Inside ls_reports.coffee: Onchange!")
    window.location = @options[@selectedIndex].value
    return

  # Nav controls action - export dataset
  $('#export-dataset').click (e) ->
    e.preventDefault()
    src = $(this).attr('href')
    iframe = "<iframe src='#{src}' style='zoom:0.80; width:99.6%; height:700px;' frameborder='0'></iframe>"
    $('#modal_blank').find('.modal-body').empty().append(iframe)
    $('#modal_blank').modal('show')

  ##
  # Mark question widget as submitted
  # $(document).on 'click', '.new_question_widget button[type="submit"]', (event) ->
  #   console.log "Add Question to Dashboard!"
  #   event.preventDefault();
  #   #nativeFormElement = $('.new_question_widget button[type="submit"]')[0]
  #   #Rails.fire(nativeFormElement, 'submit')
  #   $(this).submit;    trigger("submit.rails");
  #   return

  #
  #Mark question widget as successfully added on ajax success
  $(document).on 'ajax:before', '.new_question_widget', (event) ->
    $(this).find('button').
          removeClass('btn-primary').addClass('btn-default').prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i>Adding to Dashboard...')
    return

  ##
  # Mark question widget as successfully added on ajax success
  $(document).on 'ajax:success', '.new_question_widget', (event, xhr, status) ->
    $(this).find('button').
        removeClass('btn-primary').addClass('btn-success').prop('disabled', true).html("Added to Dashboard")
    return

  ##
  # Mark question widget as error when ajax call fails
  $(document).on 'ajax:error', '.new_question_widget', (event, xhr, status) ->
    if xhr.responseJSON? && xhr.responseJSON.message?
      msg = xhr.responseJSON.message
    else
      msg = 'Server Error'
    $(this).find('button').
        removeClass('btn-primary').addClass('btn-danger').prop('disabled', true).html(msg)
    return

  ##
  # Auto disable and select the drop when they are 2 or less options
  $("#pk_selector, #agg_selector").each ->
    if $(this).find("option").length <= 2
      $(this).
              prop("disabled", true).
              attr('title','Disabled because only one option is available').
              attr('data-toggle', 'tooltip').
              find("option").last().attr("selected", true)
    return
  return
