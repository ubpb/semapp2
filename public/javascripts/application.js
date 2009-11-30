(function($) {

  $.fn.item_highlight = function() {
    this.addClass("highlight");
    return this;
  };

  $.fn.item_unhighlight = function() {
    this.removeClass("highlight");
    return this;
  };

  $.fn.item_toolbar_show = function() {
    this.find(".toolbar").show();
    return this;
  };

  $.fn.item_toolbar_hide = function() {
    this.find(".toolbar").hide();
    return this;
  };

  $(function() {
    // Dom ready...
  });

})(jQuery)