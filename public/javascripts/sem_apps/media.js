(function($) {

  $(function() {

    function deleteEntry(item, url) {
      //alert(url);
      item.slideUp(500);
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

  });

})(jQuery)