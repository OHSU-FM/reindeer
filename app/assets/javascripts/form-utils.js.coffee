
window.Modal = {}
window.Modal.template = '''
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

window.FormUtils = {}
window.FormUtils.error_templates = {
    default: '''
<div class='bs-callout bs-callout-danger'>
    {{error-message}}
</div>
'''
}

error_wrap = (msg, mtype) ->
    mtype ||= 'default'
    result = window.FormUtils.error_templates[mtype].replace('{{error-message}}', msg)
    return result

resource_insert = ($target, html, insert) ->
    insert = insert || ':replace'
    if insert == ':before'
      $target.before(html)
    else if insert == ':replace'
      $target.html(html)
    else if insert == ':after'
      $target.after(html)
    else
      return

resource_load = ($node) ->
    data = $node.data()
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
        success: (response) ->
            resource_insert($target, $('<div/>').html(response), insert)

$(document).ready ->
    $('body').append($.parseHTML(Modal.template))
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
    
    $('form button[type=submit][data-toggle~=replace]').click (event) ->
        console.log 'hello GGGGGGGG'

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
    

    $('a[data-toggle~=modal]').click (event) ->
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
                $('#modal_blank .modal-body').html(new_html)
