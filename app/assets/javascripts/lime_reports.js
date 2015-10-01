// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery_sticky_table_headers.js
jQuery(function($) {
$("tr[data-link]").click(function() {
window.location = this.dataset.link
});
})


jQuery(document).ready(function($){
 
   //$(".sub-question").hide();

   /* reports controller navigation bar */
    $('body#reports select[id="report_types"], body#reports select[id="report_ids"] ').change(function(){
        var id = $('body#reports select[id="report_ids"] :selected').val() + '-' + $('body#reports select[id="report_types"] :selected').val();
        var href = $('a#'+id).attr('href');
        $('#modal-report').modal('show');
        if(href){
            window.location.href = href;
        }
    });

    // Sticky table header for reports
    //$('body#reports .report thead').stick_in_parent();
    $('body#reports table.report').stickyTableHeaders({fixedOffset: $('.navbar') });
});


    function h_img(img)
    {
      img.removeClassName('arrow-open');
      img.addClassName('arrow-closed');
    }

    function s_img(img)
    {
      img.removeClassName('arrow-closed');
      img.addClassName('arrow-open');
    }

    function h_div(div)
    {
      Element.hide(div);
    }

    function s_div(div)
    {
      Element.show(div);
    }

    function t_img(img)
    {
      if ( img.hasClassName('arrow-closed') ){
          img.removeClassName('arrow-closed');
          img.addClassName('arrow-open');
      }else{
          img.removeClassName('arrow-open');
          img.addClassName('arrow-closed');
      }
    }

    function t_div(div, no_animate, img)
    {
      if (no_animate) 
        Element.toggle(div);
      else
        Effect.toggle(div, 'blind', { duration: 0.3, afterFinish: function(){set_img(div, img)} });
    }

    function set_img(div, img){
      if (div.visible()){
          s_img(img)
      }else{ 
          h_img(img);
      }
    }

    function t(div, img)
    {
      t_div($(div), false, $(img)); 
      return true;
    }

    function fn_all(div_fn, arrow_fn)
    {
      arrow_elts = document.getElementsByClassName('toggle-img');
      toggle_elts = document.getElementsByClassName('toggle-div');

      for (var i = 0, len = toggle_elts.length; i < len; ++i)
        div_fn(toggle_elts[i], true);

      for (var i = 0, len = arrow_elts.length; i < len; ++i)
        arrow_fn(arrow_elts[i]);

      return true;
    }

    function t_all()
    {
      return fn_all(t_div, t_img);
    }

    function h_all()
    {
      return fn_all(h_div, h_img);
    }

    function s_all()
    {
      return fn_all(s_div, s_img);
    }

    function yoy_all()
    {
      toggles = $$('.toggle-div')

      for (var i = 0, len = toggles.length; i < len; ++i) {
        if ($$('#' + toggles[i].id + '-ext .right').length > 0) {
          $(toggles[i].id + '-ext').show();
          $(toggles[i].id + '-normal').hide();
        }
      }
    }

    function normal_all()
    {
      toggles = $$('.toggle-div')

      for (var i = 0, len = toggles.length; i < len; ++i) {
        if ($$('#' + toggles[i].id + '-ext .right').length > 0) {
          $(toggles[i].id + '-ext').hide();
          $(toggles[i].id + '-normal').show();
        }
      }
    }
    

