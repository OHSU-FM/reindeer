class @Assignments.SimpleMDE
    # Init
    constructor: (target, viewer_nodes, mde_opts={}) ->
        @$target = $(target)
        @$form = @$target.parents('form')
        @$viewer_nodes = $(viewer_nodes)

        # Create simplemde 
        mde_opts['element'] = @$target[0]
        @simplemde = new window.SimpleMDE(mde_opts);

        # Do UI work 
        @ui_mods()

        # Register event handlers 
        @event_handlers()

        # Update viewers with html content
        @refresh_viewer()
        return

    # Update preview of html
    refresh_viewer: ->
        klass = @
        @$viewer_nodes.each ->
            $(this).html( klass.simplemde.markdown(klass.simplemde.element.value) );
    
    # Manually touch codemirror to show editor content
    refresh_editor: ->
        klass = @
        setTimeout(->
            klass.simplemde.codemirror.refresh()
        , 200)

    # UI modifications to SimpleMDE
    ui_mods: ->
        # Adjust SimpleMDE UI - Hide elements 
        @$form.find('a[title="Toggle Fullscreen (F11)"]').remove()
        @$form.find('a[title="Toggle Side by Side (F9)"]').remove()

    # All event handlers
    event_handlers: ->
        # Alias @ to klass for callback 
        klass = @

        # Update viewer on save
        @$form.on 'ajax:success', (event) ->
            klass.refresh_viewer()
        
        return

