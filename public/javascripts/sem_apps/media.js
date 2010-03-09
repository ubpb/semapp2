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

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

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
    })

  });

})(jQuery)