//= require entries/delete
//= require entries/reorder

(function($) {

  $(function() {

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    $('body').bind('media-tab-loaded', function() {

      $('#new-entry-panel .close').live('click', function() {
        $('#new-entry-panel').overlay().close();
      });

      /** The user clicks the link to delete an entry */
      $(".delete-entry-action").live('click', function(event) {
        event.preventDefault();
        var item = $(this).closest(".item");
        var url  = $(this).attr("href");

        var ret = confirm("Eintrag wirklich löschen?");
        if (ret === true) {
          app.entries['delete'](item, url);
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
          app.entries.reorder(url);
        }
      });

    });
    
  });

})(jQuery);
