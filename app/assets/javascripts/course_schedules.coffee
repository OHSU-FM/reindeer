# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.addEventListener 'load', ->
  flatpickr '#start_date',
     allowInput: true,
     dateFormat: "Y-m-d",
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    #$('#endDate1').val($('#startDate1').val())
  return


$(document).ready ->
  flatpickr '#end_date',
     allowInput: true,
     dateFormat: "Y-m-d",
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    #$('#endDate1').val($('#startDate1').val())
  return
