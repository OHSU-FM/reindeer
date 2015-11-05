$(document).ready ->
    return if $('body').attr('id') != 'assignment_groups'

    $('select.select2').select2();

