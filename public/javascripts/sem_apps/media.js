(function($) {

  $(function() {

    function deleteEntry(item, url) {
      //alert(url);
      item.slideUp(500);
    }

    function createEntry(item, url) {
      alert("TBD: Neuen Eintrag erstellen");
    }

    function reorderEntries(url) {
      var orderedList = $("#media-listing").sortable('serialize');
      console.debug(orderedList);

      $.ajax({
        type: "put",
        data: "_method=put&" + orderedList,
        async: true,
        url: url,
        success: function() {
          console.debug("resorder sucessfull");
        },
        error: function() {
          console.debug("reorder failed");
        }
      });
    }

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    /** If the user clicks the link to delete an antry */
    jQuery(".delete-entry-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      var ret = confirm("Soll der Eintrag wirklich aus der Liste gelöscht werden? Diese Aktion kann nicht Rückgängig gemacht werden.");
      if (ret == true) {
        deleteEntry(item, url);
      }
    });

    /** If the user clicks the link to create a new antry */
    jQuery(".create-entry-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      createEntry(item, url);
    });

    /** Make media entries sortable with the mouse */
    jQuery(".reorder-entry-action").live('click', function(event) {
      event.preventDefault();
    });

    jQuery("#media-listing").sortable({
      items : '.item',
      handle: '.reorder-entry-action',
      update: function(event, ui) {
        var url = ui.item.find(".reorder-entry-action").attr("href");
        reorderEntries(url);
      }
    })

  });

})(jQuery)