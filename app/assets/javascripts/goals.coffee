$(document).on 'click', '#cs-sidebar-toggle', (e)->
  console.log('toggle')
  $('#cs-goals-nav').toggleClass('open')

$(document).on 'click', '#show-detail', (e)->
  console.log('show detail')
  $('#cs-goals-detail').toggleClass('show-goal-detail')

$(document).on 'click', '#hide-detail', (e)->
  console.log('hide detail')
  $('#cs-goals-detail').removeClass('show-goal-detail')

$(document).ready ->
  $("#student-select").select2()
