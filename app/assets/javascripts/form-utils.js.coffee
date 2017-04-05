
@FormUtils = {}
@FormUtils.modal_template = '''
<div id="modal_blank" class="modal fade" tabindex="-1" role="dialog" data-keyboard="true" style="display:none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title"></h4>
              </ul>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer" style="text-align: center">
                <button id="modal_cancel" type="button" class="btn btn-default" data-dismiss="modal" onclick="window.stop()">Close</button>
            </div>
        </div>
    </div>
</div>
    '''

@FormUtils.error_templates = {
    default: '''
<div class='bs-callout bs-callout-danger'>
    {{error-message}}
</div>
'''
}

class @FormUtils.DataEvents
    initialize: (nodes) ->
        @$nodes = nodes
        @event_handlers()

@FormUtils.classifier = (doc) ->
    # Automagic behavior for html objects
    $(doc).find('[data-class]').each ->
        new_class = window
        try
            $($(this).data('class').split('.')).each ->
                new_class = new_class[this]
        catch e
            console.log('FormUtils.classifier: Class not found => ' + $(this).data('class'))
            throw e
        new new_class($(this))

# Wrap error message within template
error_wrap = (msg, mtype) ->
    mtype ||= 'default'
    result = window.FormUtils.error_templates[mtype].replace('{{error-message}}', msg)
    return result

# Insert / replace html near target
resource_insert = ($target, html, insert) ->
    # Method to call on target
    switches = {
        ':before': 'before',
        ':replace': 'html',
        ':after': 'after'
    }
    # Set default method
    insert = insert || ':replace'
    # Call Method
    $target[switches[insert]](html)
    # Initialize automagic classifiers
    FormUtils.classifier(html)
    return

# Load resource
resource_load = ($node, data) ->
    data = data || $node.data()
    $target = $(data.target)
    method = data.method || 'GET'
    url = $node.attr('href') || data.url
    insert = data.insert
    $.ajax
        url: url
        type: method
        data:
            layout: false
        dataType: 'html'
        contentType: 'application/html; charset=utf-8'
        error: (data, g1, g2) ->
            resource_insert($target, error_wrap('Error: ' + g2), insert)
            $(data.onResourceErrorShow).show() if data.onResourceErrorShow?
            $(data.onResourceErrorHide).hide() if data.onResourceErrorHide?
            $(data.onResourceErrorRemove).remove() if data.onResourceErrorRemove?
        success: (response) ->
            resource_insert($target, $('<div/>').html(response), insert)
            $(data.onResourceSuccessShow).show() if data.onResourceSuccessShow?
            $(data.onResourceSuccessHide).hide() if data.onResourceSuccessHide?
            $(data.onResourceSuccessRemove).remove() if data.onResourceSuccessRemove?
        complete: ->
            alert(data)
            $(data.onResourceCompleteShow).show() if data.onResourceCompleteShow?
            $(data.onResourceCompleteHide).hide() if data.onResourceCompleteHide?
            $(data.onResourceCompleteRemove).remove() if data.onResourceCompleteRemove?


$(document).ready ->
    # Add template modal to body
    $('body').append($.parseHTML(FormUtils.modal_template))

    FormUtils.classifier(document)

    # Automatic data actions
    $(document).on 'click', 'button,a', (event) ->
        $node = $(this)
        data = $node.data()
        $(data.show).show() if data.show?
        $(data.hide).hide() if data.hide?
        $(data.remove).remove() if data.remove?

        if data.copyVal
            $target = $(data.target)
            message = $(data.copyVal).val()
            resource_insert($target, message)

        if data.action == 'resource-load'
            event.preventDefault()
            event.stopImmediatePropagation()
            resource_load($node)
        return

    # replace_on_submit
    $('form button[type=submit][data-toggle~=replace]').click (event) ->

    # link_to_update_content
    $('a[data-toggle~=replace]').click (event) ->
        event.preventDefault()
        event.stopImmediatePropagation()
        $target = $($(this).data().target)
        url = this.href
        $target.html('Loading...')
        $.ajax
            url: url
            type: 'GET'
            data:
                layout: false
            dataType: 'html'
            contentType: 'application/html; charset=utf-8'
            error: (data, g1, g2) ->
                $target.html('Error<br/>' +g2)
            success: (data) ->
                new_html = $('<div/>').html(data)
                $target.html(new_html)

    # link_to_modal_dialog
    $('body').on 'click', 'a[data-toggle~=modal]', (event) ->
        event.preventDefault()
        event.stopImmediatePropagation()
        url = this.href
        method = $(this).data().method || 'GET'
        $('#modal_blank .modal-title').html('')
        $('#modal_blank .modal-body').html('')
        $('#modal_blank').modal('show')
        $.ajax
            url: url
            type: method
            data:
                layout: false
            dataType: 'html'
            contentType: 'application/html; charset=utf-8'
            error: (data, g1, g2) ->
                $('#modal_blank .modal-title').html('Error')
                $('#modal_blank .modal-body').html(g2)
            success: (data) ->
                new_html = $('<div/>').html(data)
                title = new_html.find('.page-header').remove()
                $('#modal_blank .modal-title').html(title.text())
                $('#modal_blank .modal-body').html(new_html.find('.modal-body-content'))
