// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery_sticky_table_headers.js
// require scriptaculous/prototype.js
// require scriptaculous/effects.js
// require scriptaculous/controls.js
// require scriptaculous/dragdrop.js
//

jQuery(document).ready(function($){
    
    var page = $('body#reports');
    if(page.length == 0){return;}
    
    page.attr('data-spy', 'scroll');
    page.attr('data-target', '#scroll-spy-nav');

    // Offset of page once we have set sticky headers
    var offset_top = 137;
    
    /* reports controller navigation bar */
    $('body select[id="report_types"], body#reports select[id="report_ids"] ').change(function(){
        var id = $('body#reports select[id="report_ids"] :selected').val() + '-' + $('body#reports select[id="report_types"] :selected').val();
        var href = $('a#'+id).attr('href');
        jQuery('#modal_nav_reports').modal('show');
        if(href){
            window.location.href = href;
        }
    });

    // Sticky table header for reports
    //$('body#reports .report thead').stick_in_parent();
    $('body table.report').stickyTableHeaders({fixedOffset: $('.navbar') });

    $("body").scrollspy({target: "#scroll-spy-nav", offset: offset_top});

    /* Refresh scroll-spy list (likely not needed) */
    $('[data-spy="scroll"]').each(function(){
            $(this).scrollspy('refresh');
            console.log('We refreshed');
    });

    /* Alternately hide or show child lists */
    $("body").on('activate', function() {
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

    /* Smooth scroll hashtag links*/
    $('#scroll-spy-nav a[href^="#"]').on('click',function (e) {
        e.preventDefault();

        var target = this.hash;
        var $target = $(target);

        $('html, body').stop().animate({
            'scrollTop': $target.offset().top - (offset_top - 5)
        }, 400, 'swing', function () {
            window.location.hash = target;
        });
    });

    // Open when clicked
    $(document).on('click', '.toggle-img', function(event){
        toggle_row(this);
    });

    // Hide all rows 
    $(document).on('click', '.hide-all-rows', function(event){
        $('.toggle-div').hide();
        $('.arrow-open').removeClass('arrow-open').addClass('arrow-closed');
    });
    // Show all rows
    $(document).on('click', '.show-all-rows', function(event){
        $('.toggle-div').show();
        $('.arrow-closed').removeClass('arrow-closed').addClass('arrow-open');
    });
    // Toggle all rows
    $(document).on('click', '.toggle-all-rows', function(event){
        $('.toggle-div').toggle();
        $('.arrow div').toggleClass('arrow-closed').toggleClass('arrow-open');
    });
    // Show all normal
    $(document).on('click', '.show-all-normal', function(event){
        $('.toggle-div div[id$="-ext"]').hide();
        $('.toggle-div div[id$="-normal"]').show();
    });
    // Show all yoy
    $(document).on('click', '.show-all-yoy', function(event){
        $('.toggle-div div[id$="-ext"]').show();
        $('.toggle-div div[id$="-normal"]').hide();
    });
    // Show normal
    $(document).on('click', '.show-normal', function(event){
        $(this).parents('.toggle-div').find('div[id$="-ext"]').hide();
        $(this).parents('.toggle-div').find('div[id$="-normal"]').show();
    });
    // Show yoy
    $(document).on('click', '.show-yoy', function(event){
        $(this).parents('.toggle-div').find('div[id$="-ext"]').show();
        $(this).parents('.toggle-div').find('div[id$="-normal"]').hide();
    });

    function toggle_row(node){
        var row = $(node).parents('tr');
        var open_row = row.find('.arrow-open');
        if(open_row.length > 0){
            hide_row(node);
        }else{
            show_row(node);
        }
    
    }
    // hide sub
    function hide_row(node){
        $(node).parents('tr').find('.arrow-open').removeClass('arrow-open').
            addClass('arrow-closed').parents('tr').next().find('.toggle-div').slideUp();
    }
    // show sub
    function show_row(node){
        $(node).parents('tr').find('.arrow-closed').removeClass('arrow-closed').
            addClass('arrow-open').parents('tr').next().find('.toggle-div').slideDown();
    }

});

