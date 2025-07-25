
window.addEventListener 'load', ->
  flatpickr '#precep_meeting_meeting_date',
     allowInput: true,
     enableTime: false,
     minTime: "07:00",
     maxTime: "20:00",
     altInput: false,
     dateFormat: "Y-m-d",
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
  return

$(document).ready ->
  console.log(" ** inside precep_meetint.coffee! **")
