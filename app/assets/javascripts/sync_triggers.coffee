# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery(document).ready ->
    $ = jQuery

    on_error = (data) ->
        modal = $('#modal_blank')
        modal.find('.modal-header').html('<h3>Sync Trigger <span class="label label-danger">Error</span><h3>')
        modal.find('.modal-body').html('<div class="bs-callout bs-callout-danger">Ooops, there was an error.</div>')
        modal.modal('show')

    on_update = (data, title) ->
        modal = $('#modal_blank')
        title = if title == undefined then 'New' else title
        modal.find('.modal-header').html('<h3>Sync Trigger <span class="label label-primary">'+title+'</span><h3>')
        modal.find('.modal-body').html(data)
        modal.modal('show')
     
    $(document).on 'ajax:beforeSend', 'form#new_lime_ext_sync_trigger', ->
        $modal = $('#modal_blank')
        $modal.find('#modal_cancel').html('Cancel')
        $(this).find(':input').prop('disabled', true)

    # Show modal builder form for creating new trigger
    $(document).on 'click', 'button.modal-view-trigger-desc', (e) ->
        $.ajax
            url: $(this).data().link
            method: 'get'
            error: (data) ->
                on_error(data)
            success: (data, status, response) ->
                on_update(data, 'Description')

    # Send form to server for update
    $(document).on 'change', 'form#new_lime_ext_sync_trigger input, form#new_lime_ext_sync_trigger select', ->
        $form = $(this).parents('form')
        $form.attr('action', $form.data().builderPath)
        $form.attr('method', 'get').trigger('submit.rails') 
   
    # Mark modal form for shutdown if we are posting
    $(document).on 'ajax:before', 'form#new_lime_ext_sync_trigger', (event) ->
        $(this).data('close', event.target.method == 'post')
    
    # Notify user that a server side error has occurred
    $(document).on 'ajax:error', 'form#new_lime_ext_sync_trigger', (_, data, response) ->
        on_error(data)

    # Update modal content with response data from server
    $(document).on 'ajax:success', 'form#new_lime_ext_sync_trigger', (_, data, response) ->
        $target = $('#modal_blank .modal-body')
        if $(this).data().close 
            $target = $('body')
            $('#modal_show').modal('hide')
        $target.html(data)
    
    # Allow deleting a column line in modal builder
    $(document).on 'click', 'form#new_lime_ext_sync_trigger .delete-row', ->
        $form = $(this).parents('form')
        $(this).parents('tr').remove();
        $form.attr('action', $form.data().builderPath)
        $form.attr('method', 'get').trigger('submit.rails') 

    # Show modal builder form for creating new trigger
    $(document).on 'click', '#sync-trigger-new', ->
        modal = $('#modal_blank')
        modal.find('#modal_cancel').html('Cancel')
        $.ajax
            url: $(this).data().link
            method: 'get'
            error: (data) ->
                on_error(data)
            success: (data, status, response) ->
                on_update(data)
