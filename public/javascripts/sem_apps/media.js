(function($) {

  $(function() {


    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    /** If the user hovers over entries with the mouse, show/hide a toolbar. */

    $("#media-listing .item").live('mouseover', function() {
      $(this).item_highlight();
      $(this).item_toolbar_show();
    });

    $("#media-listing .item").live('mouseout', function() {
      $(this).item_unhighlight();
      $(this).item_toolbar_hide();
    });

  });

})(jQuery)