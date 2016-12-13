$(document).ready ->   
    $(".spreadsheet ").DataTable({"aLengthMenu":[[25,50,100,200,-1],[25,50,100,200,"All"]],
    dom: '<"H"Tfr>t<"F"ip>', 
    tableTools: {aButtons: ["copy",
                              {
                                    "sExtends": "collection", 
                                    "sPdfOrientation": "landscape",
                                    "sButtonText": 'Save <span class="caret" />',
                                    "aButtons":    [ "csv", "xls" ]
                                }], sSwfPath: window.BASE_URL+"assets/dataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf" }}  )
    
    $.extend( true, $.fn.DataTable.TableTools.classes, {
        "container": "btn-group",
        "buttons": {
                    "normal": "btn",
                    "disabled": "btn disabled"
                    },
        "collection": {
                        "container": "DTTT_dropdown dropdown-menu",
                        "buttons": {
                            "normal": "",
                            "disabled": "disabled"
                        }
                      }
        } );

    $.extend( true, $.fn.DataTable.TableTools.DEFAULTS.oTags, {
        "collection": {
                        "container": "ul",
                        "button": "li",
                        "liner": "a"
                      }
     } );
 
    $('[title]').each ->
        $(this).tooltip
            placement: if typeof $(this).attr('data-placement') == 'undefined' then 'bottom' else $(this).attr('data-placement')
            trigger: 'hover'
        return


    
