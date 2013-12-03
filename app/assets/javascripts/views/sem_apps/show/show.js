(function($) {

  $(function() {
    // Load Sem App tabs via ajax
    loadBooksTab();
    loadMediaTab();

    function loadMediaTab() {
      loadSemAppTab('#media-tab', function() {
        $('body').trigger('media-tab-loaded');
      });
    }

    function loadBooksTab() {
      loadSemAppTab('#books-tab', function() {
        $('body').trigger('books-tab-loaded');
      });
    }

    function loadSemAppTab(tab_id, callback) {
      var tab = $(tab_id);
      var url = tab.attr("rel");

      tab.html('<div class="pui-panel align-center"><img src="/assets/pui/common/loader.gif" style="line-height:16px; vertical-align:text-top"/> Lade Daten ...</div>');

      $.ajax({
        url: url,
        dataType: "html",
        success: function(data) {
          tab.html(data);
          callback();
        },
        error: function(request, settings, thrownError) {
                tab.append( "<li>Error requesting page " + settings.url + ": " +
                    thrownError + " in " + thrownError.fileName + ":" +
                    thrownError.lineNumber + ":" + thrownError.columnNumber + ") </li>" );
              }
        }
      );
    }

  });

})(jQuery);
