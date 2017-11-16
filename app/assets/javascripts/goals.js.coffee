# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery(document).on 'turbolinks:load', ->
  action_plan_items = $('#action_plan_items')
  count = action_plan_items.find('.count > span')

  recount = -> count.text action_plan_items.find('.nested-fields').size()

  action_plan_items.on 'cocoon:before-insert', (e, el_to_add) ->
    el_to_add.fadeIn(1000)

  action_plan_items.on 'cocoon:after-insert', (e, added_el) ->
    added_el.effect('highlight', {}, 500)
    recount()

  action_plan_items.on 'cocoon:before-remove', (e, el_to_remove) ->
    $(this).data('remove-timeout', 1000)
    el_to_remove.fadeOut(1000)

  action_plan_items.on 'cocoon:after-remove', (e, removed_el) ->
    recount()



