class @Assignments.MarkdownForm
    initialize: form, ->
        desc_show = form.find('.md-show button')
        desc_input = form.find('textarea')
        desc_viewer = form.find('.md-content')
        @simplemde = new Assignments.SimpleMDE(desc_input, desc_viewer, desc_show)
        @event_handlers()

    event_handlers: ->
        klass = @
        # Fix simplemde refresh on CodeMirror show
        form.find('.md-show button').on 'click', (event) ->
            klass.simplemde.refresh_editor()

