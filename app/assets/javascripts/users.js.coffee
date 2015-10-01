$(document).ready () ->
    $(document).on 'show.bs.collapse', 'body#users .ua-accordion', ->
        $panel = $(this)
        link = $panel.find('a').first().data().url
        $iframe = $panel.find('iframe')
        if $iframe.length == 0
            $iframe = $('<iframe>', {src: link, class: 'ua-iframe-link', sandbox: 'allow-forms allow-scripts allow-same-origin'})
            $panel.find('.panel-body').append($iframe)
            return


    $(document).on 'hidden.bs.collapse', 'body#users .ua-accordion', ->
        $iframe = $(this).find('iframe')
        if $iframe.length > 0
            $iframe.remove()
        return

