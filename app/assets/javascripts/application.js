// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.7.2.custom.min
//= require jquery-tools-1.1.2.min
//= require jquery-form-2.33
//= require markitup/jquery.markitup.pack
//= require markitup/sets/textile/set
//= require pui
//= require_tree

(function($) {

  $.fn.item_highlight = function() {
    if ($.frozen === true) return this;
    this.addClass("highlight");
    return this;
  };

  $.fn.item_unhighlight = function() {
    if ($.frozen === true) return this;
    this.removeClass("highlight");
    return this;
  };

  $.fn.item_toolbar_show = function() {
    if ($.frozen === true) return this;
    this.find(".toolbar-wrapper").show();
    this.find(".toolbar").show();
    return this;
  };

  $.fn.item_toolbar_hide = function() {
    if ($.frozen === true) return this;
    this.find(".toolbar-wrapper").hide();
    this.find(".toolbar").hide();
    return this;
  };

  $(function() {
    // enable markitup
    $('.textile').markItUp(markItUpTextileSettings);
  });

})(jQuery);
