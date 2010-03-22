(function($) {

  $(function() {

    /***********************************************************************************
     * API
     **********************************************************************************/

    function reorderEntries(url) {
      var orderedList = $("#media-listing").sortable('serialize');
      $.ajax({
        type: "put",
        data: "_method=put&" + orderedList,
        async: true,
        url: url
      });
    }

    function deleteEntry(item, url) {
      item.slideUp(500);
      
      $.ajax({
        type: "delete",
        data: "_method=delete",
        async: true,
        url: url
      });
    }

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    $('body').bind('media-tab-loaded', function() {

      /** The user clicks the link to create a new entry */
      $(".new-entry-action").live('click', function(event) {
        event.preventDefault();
        var url = $(this).attr("href");
        $.get(url, function(data) {
          $('#new-entry-panel').html(data).append('<div class="close"></div>');
          $('#new-entry-panel').overlay({
            expose: {
              color: '#333',
              loadSpeed: 150,
              opacity: 0.6
            },
            closeOnClick: false,
            api: true
          }).load();
        });
      });

      $('#new-entry-panel .close').live('click', function() {
        $('#new-entry-panel').overlay().close();
      });

      /** The user clicks the link to delete an entry */
      $(".delete-entry-action").live('click', function(event) {
        event.preventDefault();
        var item = $(this).closest(".item");
        var url  = $(this).attr("href");

        var ret = confirm("Eintrag wirklich löschen?");
        if (ret == true) {
          deleteEntry(item, url);
        }
      });

      /** Make media entries sortable with the mouse */
      $(".reorder-entry-action").live('click', function(event) {
        event.preventDefault();
      });

      $("#media-listing").sortable({
        items      : '.item',
        handle     : '.reorder-entry-action',
        scrollSpeed: 10,
        helper     : 'clone',
        start: function() {
          $.frozen = true;
        },
        stop: function() {
          $.frozen = false;
        },
        update: function(event, ui) {
          var url = ui.item.find(".reorder-entry-action").attr("href");
          reorderEntries(url);
        }
      });

    });
    
  });

})(jQuery)