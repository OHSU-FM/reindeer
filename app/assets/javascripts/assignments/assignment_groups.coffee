$(document).ready ->
    return if $('body').attr('id') != 'assignment_groups'
    
    # Enable fancy select box for participants dropdown
    $('.assignment-group-user-ids').select2();

    # Enable auto-update when select changes
    $('.assignment-group-user-ids').change (e)->
        $(this).parent('form').trigger('submit.rails');

    # Enable fancy text editor for group description
    window.simplemde = new SimpleMDE({
        element: document.getElementById("MyID")
    });
    # Adjust SimpleMDE UI 
    $('a[title="Toggle Fullscreen (F11)"]').remove()
    $('a[title="Toggle Side by Side (F9)"]').remove()

    $('.md-content').html( window.simplemde.markdown(window.simplemde.element.value) );


