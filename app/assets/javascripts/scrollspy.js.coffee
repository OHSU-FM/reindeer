window.scroll_spy_init = (offset=70) ->
    #// Initialize Scroll Spy
    $("body").scrollspy({offset: offset})
    
    #/* Refresh scroll-spy list (likely not needed) */
    $('[data-spy="scroll"]').each ->
        $(this).scrollspy('refresh')
    
    #/* Smooth scroll for Scroll Spy hashtag link clicks */
    $('#scroll-spy-nav a[href^="#"]').on 'click', (e) ->
        e.preventDefault();
        $anchor = $(this)
        target = this.hash;
        $target = $(target);
        $anchor.trigger('scroll-spy-nav:before-click')

        $('html, body').stop().animate({
            'scrollTop': $target.offset().top - offset
        }, 400, 'easeInOutQuart', ->
            window.location.hash = target;
            $anchor.trigger('scroll-spy-nav:after-click')
            $('body').scrollspy('refresh')
            $(window).trigger('resize.stickyTableHeaders');
            return
        )
        return
    return

