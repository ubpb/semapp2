(function($) {

  $(function() {

    $(".listing .item").live('mouseover', function() {
      $(this).item_highlight();
      $(this).item_toolbar_show();
    });

    $(".listing .item").live('mouseout', function() {
      $(this).item_unhighlight();
      $(this).item_toolbar_hide();
    });

  });

})(jQuery);