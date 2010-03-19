(function($) {

  $(function() {
    // Load Sem App tabs via ajax
    $("#sem-app-tabs").tabs().getConf().effect = 'fade';
    loadBooksTab();
    loadMediaTab();

    function loadMediaTab() {
      load_tab('#media-tab');
    }

    function loadBooksTab() {
      load_tab('#books-tab');
    }

    function load_tab(tab_id) {
      var tab = $(tab_id)
      var url = tab.attr("rel");

      tab.html('<div class="pui-panel align-center">Lade Daten ...</div>');
      $.get(url, function(data) {
        tab.html(data);
      });
    }

  });

})(jQuery)