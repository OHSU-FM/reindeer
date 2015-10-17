
window.Modal = {}
window.Modal.template = '''
<div id="modal_blank" class="modal fade" tabindex="-1" role="dialog" data-keyboard="true" style="display:none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
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


$(document).ready ->
    $('body').append($.parseHTML(Modal.template))
    $('a[data-toggle~=modal]').click (event) ->
        event.preventDefault()
        event.stopImmediatePropagation()
        url = this.href
        $('#modal_blank').modal('show')
        $.ajax
            url: url
            type: 'GET'
            data: 
                layout: false
            dataType: 'html'
            contentType: 'application/html; charset=utf-8'
            success: (data) -> 
                $('#modal_blank .modal-body').html($(data))
