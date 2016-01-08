window.Assignments.AssignmentGroup = {}

$(document).ready ->
    return if $('body').attr('id') != 'assignment_groups'
    
    # Enable fancy select box for participants dropdown
    $('.assignment-group-user-ids').select2();

    # Enable auto-update when user select changes
    $('.assignment-group-user-ids').change (e)->
        $(this).parents('form').trigger('submit.rails');
    
    #$form = $('form.edit_assignment_assignment_group')
    #desc_show = $form.find('.md-show button')
    #desc_input = $form.find('textarea')
    #desc_viewer = $form.find('.md-content')
    #window.simplemde = new Assignments.SimpleMDE(desc_input, desc_viewer, desc_show)

    ## Fix simplemde refresh on CodeMirror show
    #$form.find('.md-show button').on 'click', (event) ->
    #    window.simplemde.refresh_editor()

