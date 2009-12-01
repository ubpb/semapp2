(function($) {

  $.fn.item_highlight = function() {
    if ($.frozen == true) return this;
    this.addClass("highlight");
    return this;
  };

  $.fn.item_unhighlight = function() {
    if ($.frozen == true) return this;
    this.removeClass("highlight");
    return this;
  };

  $.fn.item_toolbar_show = function() {
    if ($.frozen == true) return this;
    this.find(".toolbar").show();
    return this;
  };

  $.fn.item_toolbar_hide = function() {
    if ($.frozen == true) return this;
    this.find(".toolbar").hide();
    return this;
  };

  $(function() {
    // Dom ready...
  });

})(jQuery)