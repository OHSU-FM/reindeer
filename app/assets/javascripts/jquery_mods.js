
/*
 
Usage: $.windowResize(yourFunction);
 
Intended as a replacement for $(window).resize(yourFunction)
yourFunction will only be called once the resize action has been completed, improving performance
 
Code is public domain

    https://gist.github.com/quis/2070586

*/
 
jQuery.windowResize = (function($) {
        
    var enqueue = function() { // Setter method for the queue of callbacks
    
            var callbacks = Array.prototype.slice.call(arguments);
        
            for (var i in callbacks) queue.push(callbacks[i]);
 
        },
        flush = function() { // Check every 300ms to see if resize has finished
 
            clearTimeout(timer);
            
            timer = setTimeout(doCallbacks, 300);
        
        },
        doCallbacks = function() { // Run any functions that have been queued
        
            for (var i in queue) queue[i].call(window);
        
        },
        timer,
        queue = [];
        
    $(function() {
    
        $(window)
            .resize(flush); // Bind to jQuery window object just once
    
    });            
 
    return enqueue;
 
})(jQuery);

jQuery.fn.extend({
    colorFlash: function(options){
        defaults = {
            color: '#FF0000',
            duration: 500,
            delay: 500
        }
        var opts = $.extend( {}, defaults, options);
        var old_color = $(this).css('background-color');
        $(this).animate({backgroundColor: opts.color}, {duration:opts.duration});
        $(this).delay(opts.delay);
        $(this).animate({backgroundColor: old_color}, {duration:opts.duration});
        return this;
    }
});


$.fn.isOnScreen = function(){
    var element = this.get(0);
    var bounds = element.getBoundingClientRect();
    return bounds.top < window.innerHeight && bounds.bottom > 0;
}
