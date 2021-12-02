$(document).ready ->
  $("[id^=MyModalEPA]").draggable handle: '.modal-body'
  $('#WbaReportTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
