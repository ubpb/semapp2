(function($) {

  $(function() {

    /** Highlights a given entry */
    function highlightItem(item) {
      item.addClass("highlight");
    }

    /** Unhighlights a given entry */
    function unhighlightItem(item) {
      item.removeClass("highlight");
    }

    /** Shows the toolbar for a given entry */
    function showToolbar(item) {
      item.find(".toolbar").show();
    }

    /** Hides the toolbar for a given entry */
    function hideToolbar(item) {
      item.find(".toolbar").hide();
    }

    /**
     * Deletes a book from the listing.
     */
    function deleteBook(item, url) {
      jQuery.ajax({
        type: "delete",
        data: "_method=delete",
        async: true,
        url: url,
        success: function() {
          item.slideUp(500);
        },
        error: function() {
          alert("Beim Versuch den Eintrag zu löschen ist ein Fehler aufgetreten. Laden Sie die Seite neu und versuchen Sie es erneut. Sollte es wiederholt zu einem Fehler kommen, kontaktieren Sie bitte den Support.");
        }
      });
    }

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    /** If the user hovers over books with the mouse, show/hide a toolbar. */

    $("#books-listing .item").live('mouseover', function() {
      highlightItem($(this));
      showToolbar($(this));
    });

    $("#books-listing .item").live('mouseout', function() {
      unhighlightItem($(this));
      hideToolbar($(this));
    });

    /** If the user clicks the link to delete a book */
    jQuery(".delete-book-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      var ret = confirm("Soll das Buch wirklich aus der Liste gelöscht werden? Wenn Sie diese Aktion bestätigen wird das Buch ebenfalls aus dem Regal in der Bibliothek entfernt und in den normalen Bestand aufgenommen.");
      if (ret == true) {
        deleteBook(item, url);
      }
    });

  });

})(jQuery)