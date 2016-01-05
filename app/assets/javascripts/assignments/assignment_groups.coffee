window.Assignments.AssignmentGroup = {}

$(document).ready ->
    return if $('body').attr('id') != 'assignment_groups'
    
    # Enable fancy select box for participants dropdown
    $('.assignment-group-user-ids').select2();

    # Enable auto-update when select changes
    $('.assignment-group-user-ids').change (e)->
        $(this).parent('form').trigger('submit.rails');

    desc_input = $('textarea#desc_md_assignment_assignment_group_desc_md')
    desc_viewer = $('.md-content')
    window.simplemde = new Assignments.SimpleMDE(desc_input, desc_viewer) 

    # Enable fancy text editor for group description
    #window.simplemde = new SimpleMDE({
    #    element: document.getElementById("desc_md_assignment_assignment_group_desc_md")
    #});

    # Fix simplemde refresh on CodeMirror show
    $('form.edit_assignment_assignment_group .md-show button').on 'click', (event) ->
        window.simplemde.refresh_editor()

    # Update viewer on save
    #$('form.edit_assignment_assignment_group').on 'ajax:success', (event) ->
    #    $('.md-content').html( window.simplemde.markdown(window.simplemde.element.value) );


    # Adjust SimpleMDE UI - Hide elements 
    #$('a[title="Toggle Fullscreen (F11)"]').remove()
    #$('a[title="Toggle Side by Side (F9)"]').remove()
    
    # Update viewer content
    #$('.md-content').html( window.simplemde.markdown(window.simplemde.element.value) );
