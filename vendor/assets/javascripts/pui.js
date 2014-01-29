(function($) {

  /**
     * Make sure jquery sends an authenticity token on every ajax request
     */
  $.alwaysSendAuthToken = function(authToken) {
    $(document).ajaxSend(function(event, request, settings) {
      if (!authToken || typeof(authToken) == "undefined") return;
      if (settings.type == 'GET' || settings.type == 'get') return; // Don't add anything to a get request let IE turn it into a POST.
      settings.data = settings.data || "";
      settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(authToken);
    });
  };

  /**
     * Default stuff when DOM is loaded
     */
  $(function() {
    // Gracefully ignore firebug script errors when firebug not present.
    // http://snippets.dzone.com/posts/show/6326
    if (! ("console" in window) || !("firebug" in console)) {
      var names = ["log", "debug", "info", "warn", "error", "assert", "dir", "dirxml", "group", "groupEnd", "time", "timeEnd", "count", "trace", "profile", "profileEnd"];
      window.console = {};
      for (var i = 0; i <names.length; ++i) {
        window.console[names[i]] = function() {};
      }
    }

    //
    // PUI overlays
    //
    $("a[rel].pui-overlay-trigger").overlay({
      expose: {
        color: '#333',
        loadSpeed: 150,
        opacity: 0.6
      },
      closeOnClick: false
    });

    //
    // PUI tabs
    //
    $("div.pui-tabs-wrapper:not(.pui-tabs-non-js) > ul.pui-tabs").tabs("div.pui-tab-panes > div").history();
  });

})(jQuery)
