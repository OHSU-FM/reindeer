#= require ./model_tooltips.js

$(document).on 'nested:fieldAdded', 'form', (content) ->
    if $(this).attr('id') == 'edit_permission_group' 
        # Hide lime_question field if this is a new survey permission group
        $(content.target).
            find('.lime_question_field').
            append('<label class="control-label">* Must set an "Ident Type" and save before a question can be selected</label>').
            find('.controls').hide()

$(document).on 'change', '.restricted_val_field input, .ident_type_field input', (e) ->
    check_text.call(this)

check_text = () ->
    $us = $(this) 
    fieldset = $us.parents('fieldset').first()

    if $us.parents('.restricted_val_field').length > 0
        msg = 'Restricting by value'
        $them = fieldset.find('.ident_type_field input')
    else
        msg = 'Restricting by ident'
        $them = fieldset.find('.restricted_val_field input') 

    us_empty = $us.val() == ''

    if us_empty
        $them.prop('readonly', false).
            addClass('required').attr('placeholder', '')
    else 
        $them.prop('readonly', true).
            val([]).removeClass('required').attr('placeholder', msg)
    #$us.attr('placeholder', '')


$(document).on 'ready page:load', (e) ->
    $('.permission_ls_groups_field .ident_type_field input, .permission_ls_groups_field .restricted_val_field input').each (idx, elem) ->
        check_text.call(this)

