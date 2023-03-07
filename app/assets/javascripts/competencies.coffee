# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#CollapsibleWbaTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
  $('[data-toggle="tooltip"]').tooltip()
  # $('#CompetencesDetailTable').DataTable 'ordering': true
  # $('.dataTables_length').addClass 'bs-select'

  toggler = $(".caret")
  i = 0

  while i < toggler.length
    toggler[i].parentElement.querySelector(".nested").classList.toggle("active")
    toggler[i].classList.toggle("caret-down")
    console.log ("toggler i: " + i)
    i++

  i = 0
  console.log("toggler length: " + toggler.length)
  while i < toggler.length
    toggler[i].addEventListener 'click', ->
      parentElement.querySelector('.nested').classList.toggle 'active'
      classList.toggle 'caret-down'
      return
    i++


  # return
