(function($) {

  $(function() {

    $(".item").live('mouseover', function() {
      if ($(this).hasClass('no-hover')) return;

      $(this).item_highlight();
      $(this).item_toolbar_show();
    });

    $(".item").live('mouseout', function() {
      $(this).item_unhighlight();
      $(this).item_toolbar_hide();
    });

  });

})(jQuery);