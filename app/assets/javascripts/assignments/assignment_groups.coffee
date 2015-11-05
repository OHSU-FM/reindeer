$(document).ready ->
    return if $('body').attr('id') != 'assignment_groups'

    $('.assignment-group-user-ids').select2();
    $('.assignment-group-user-ids').change (e)->
        $(this).parent('form').trigger('submit.rails');

    simplemde = new SimpleMDE({ element: document.getElementById("MyID") });



