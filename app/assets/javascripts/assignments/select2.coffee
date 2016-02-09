class @Assignments.Select2
    constructor: (select) ->
        # Enable fancy select box for participants dropdown
        select.select2();

        # Enable auto-update when user select changes
        select.change (e)->
            $(this).parents('form').trigger('submit.rails');


