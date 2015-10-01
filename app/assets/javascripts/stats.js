/*
*= require reports
*/
jQuery(document).ready(function($){
    var page = $('body#stats');
    if(page.length==0){return;}

    // Animate question group if we were linked here with a # fragment anchor link
    if(window.location.hash != ''){
        setTimeout(function(){
            var hash = window.location.hash;
            var node = $(hash);
            if(node.length == 0){
                node = $('a[name="'+hash.replace('#','')+'"');
            }
            $('html,body').scrollTop($(node).offset().top - 200);
            node = node.parents('div.stats');
            $(node).animate({backgroundColor: '#DFDFDF'}, {duration:500});
        }, 400);
    }

    /* stats controller navigation bar for selecting year and group */
    $('body#stats select[id="stat_ids"]').change(function(){
        var id = $('body#stats select[id="stat_ids"] :selected').val();
        var href = $('a#'+id).attr('href');
        if(href){
            jQuery('#modal_nav_stats').modal('show');
            window.location.href = href;
        }
    });
    
    $('body#stats #year_selector a').click(function(){$('#modal_stats').modal('show');})

    $("body").scrollspy({target: "#scroll-spy-nav", offset: 120});

    /* Alternately hide or show child lists */
    $("#scroll-spy-nav li").on('activate', function() {
        var pnode = $(this).parents('ul li');
        if( !pnode.hasClass('sub-active')){
            /* Hide other lists */
            $(this).parentsUntil('#scroll-spy-nav').find('.sub-active').removeClass('sub-active');
            if(pnode.length > 0){
                /* Make sub lists visible */
                $(this).parents('li').addClass('sub-active');
            }else{
                $(this).addClass('sub-active');
            }
        }
    });

});

