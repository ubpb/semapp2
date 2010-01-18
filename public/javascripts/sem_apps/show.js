(function($) {

  $(function() {

    var edit_mode = false;

    /** Highlights a given entry */
    function highlightEntry(entry) {
      entry.addClass("highlight");
    }

    /** Unhighlights a given entry */
    function unhighlightEntry(entry) {
      entry.removeClass("highlight");
    }

    /** Shows the toolbar for a given entry */
    function showToolbar(entry) {
      entry.find(".toolbar").show();
    }

    /** Hides the toolbar for a given entry */
    function hideToolbar(entry) {
      entry.find(".toolbar").hide();
    }

    /**
       * Deletes an entry. It first requests a confirmation from the user.
       */
    function deleteEntry(entry, url, options) {
      // build the settings
      var settings = jQuery.extend({
        title  : "Löschen bestätigen...",
        message: "Soll der Eintrag wirklich gelöscht werden?"
      }, options || {});

      //console.debug("Delete entry action triggered:", url);
      // setup ui
      edit_mode = true;
      hideToolbar(entry);
      // let the user confirm this action
      confirmAction({
        title: settings.title,
        message: settings.message,
        onClose: function() {
          edit_mode = false;
          unhighlightEntry(entry);
        },
        onYes: function() {
          // really delete the entry on the server
          jQuery.ajax({
            type: "delete",
            data: "_method=delete",
            async: true,
            url: url,
            success: function() {
              //console.debug("Entry deleted on server: ", url);
              entry.slideUp(500, function() {
                edit_mode = false;
              });
            },
            error: function() {
              alert("Beim Versuch den Eintrag zu löschen ist ein Fehler aufgetreten. Laden Sie die Seite neu und versuchen Sie es erneut. Sollte es wiederholt zu einem Fehler kommen, kontaktieren Sie bitte den Support.");
            }
          });
        },
        onNo: function() {
          edit_mode = false;
          unhighlightEntry(entry);
        }
      });
    }

    /**
       * Shows a panel to confirm an operation (e.g. a delete operation)
       */
    function confirmAction(options) {
      // build the settings
      var settings = jQuery.extend({
        title  : "Bestätigen...",
        message: "Soll die Aktion durchgeführt werden?",
        entry  : null,
        onClose: function() {},
        onYes  : function() {},
        onNo   : function() {}
      }, options || {});

      // setup the confirmation dialog
      $('<div class="pui-overlay">moooo</div>').overlay({
        top: 272,
        expose: {
          color: '#fff',
          loadSpeed: 200,
          opacity: 0.5
        },
        api: true,
        closeOnClick: false
      }).load();


      /*
      jQuery('<div id="confirmation-dialog"></div>').dialog({
        modal: true,
        autoOpen: false,
        width: 350,
        title: settings.title,
        closeOnEscape: true,
        close: settings.onClose(),
        buttons: {
          "Ja": function() {
            jQuery(this).dialog("close");
            settings.onYes();
          },
          "Nein": function() {
            jQuery(this).dialog("close");
            settings.onNo();
          }
        }
      })
      .html(settings.message)
      .dialog("open");
      */
    }

    function createEntry(instance_type) {
      jQuery.get('<%= new_sem_app_entry_path(@sem_app) -%>', {
        instance_type: instance_type
      }, function(data) {
        entryDialog({
          html: data,
          onSave: function(dialog) {
            var form = jQuery('#entry-form');
            submitForm(form, {
              onSuccess: function(responseText) {
                dialog.dialog("close");
                jQuery('#sem-app-media-entries').prepend(responseText);
                jQuery('#no-media-entries').hide();
              },
              onError: function(responseText) {
                form.replaceWith(responseText);
                loadMCE();
              }
            });
          },
          onCancel: function(dialog) {
            dialog.dialog('close');
          }
        });
      });
    }

    function editEntry(entry, url) {
      jQuery.get(url, function(data) {
        entryDialog({
          title: "Einen Eintrag bearbeiten...",
          html: data,
          onSave: function(dialog) {
            var form = jQuery('#entry-form');
            submitForm(form, {
              onSuccess: function(responseText) {
                dialog.dialog("close");
                entry.replaceWith(responseText);
              },
              onError: function(responseText) {
                form.replaceWith(responseText);
                loadMCE();
              }
            });
          },
          onCancel: function(dialog) {
            dialog.dialog('close');
          }
        });
      });
    }

    function entryDialog(options) {
      // build the settings
      var settings = jQuery.extend({
        title   : "Einen neuen Eintrag erstellen...",
        onSave  : function(dialog) {},
        onCancel: function(dialog) {},
        html    : ""
      }, options || {});

      // (re)create the dialog
      jQuery('#entry-dialog').remove();
      var dialog = jQuery('<div id="entry-dialog"></div>').dialog({
        modal: true,
        autoOpen: false,
        width: 620,
        title: settings.title,
        closeOnEscape: true,
        buttons: {
          "Speichern": function() {
            settings.onSave(jQuery(this));
          },
          "Abbrechen": function() {
            settings.onCancel(jQuery(this));
          }
        }
      })
      .html(settings.html)
      .dialog("open");

      // (re)bind to the submit event of the form loaded into the
      // dialog to prevent default form submit.
      var form = jQuery('#entry-form');
      form.unbind("submit");
      form.bind("submit", function(event) {
        event.preventDefault();
        settings.onSave(dialog);
      });

      loadMCE();
    }

    function loadMCE() {
      jQuery('textarea.mce').tinymce({
        script_url: '/javascripts/tiny_mce/tiny_mce.js',
        theme : "advanced",
        add_form_submit_trigger : false,

        width: '100%',
        content_css: '/stylesheets/main.css',

        theme_advanced_toolbar_align: "left",
        theme_advanced_toolbar_location: "top",
        theme_advanced_statusbar_location: "bottom",
        theme_advanced_resizing: true
      });
    }

    function submitForm(form, options) {
      var opts = jQuery.extend({
        onSuccess: function(responseText) {},
        onError  : function(responseText) {}
      }, options || {});

      // handle form submission
      // (re)bind to the submit event of the form we just loaded into the editor
      form.unbind("submit");
      form.bind("submit", function(event) {
        event.preventDefault();

        if (typeof tinyMCE != 'undefined') {
          tinyMCE.triggerSave(true, true);
        }

        jQuery(this).ajaxSubmit({
          dataType: 'html',
          success: function(responseText) {
            opts.onSuccess(responseText);
          },
          error: function(xhr) {
            opts.onError(xhr.responseText);
          }
        });
      });

      // trigger the submit event of the form
      form.submit();
    }

    function reorderMediaEntries() {
      var orderedList = jQuery("#sem-app-media-entries").sortable('serialize');
      console.debug(orderedList);

      jQuery.ajax({
        type: "put",
        data: "_method=put&" + orderedList,
        async: true,
        url: "<%= reorder_sem_app_entries_path(@sem_app) -%>",
        success: function() {
          console.debug("Sort sucessfull");
        },
        error: function() {
          alert("Sortieren fehlgeschlagen");
        }
      });
    }

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/
    
    /** If the user hovers over books with the mouse, show/hide a toolbar. */

    $("#books-listing .item").live('mouseover', function() {
      highlightEntry($(this));
      showToolbar($(this));
    });

    $("#books-listing .item").live('mouseout', function() {
      unhighlightEntry($(this));
      hideToolbar($(this));
    });





    jQuery(".sem-app-entries .sem-app-entry").live('mouseover', function() {
      if (edit_mode == true) return;
      highlightEntry(jQuery(this));
      showToolbar(jQuery(this))
    });
    jQuery(".sem-app-entries .sem-app-entry").live('mouseout', function() {
      if (edit_mode == true) return;
      unhighlightEntry(jQuery(this));
      hideToolbar(jQuery(this));
    });

    /** If the user clicks the delete link of an book entry */
    jQuery(".delete-book-entry-action").live('click', function(event) {
      event.preventDefault();
      var entry = jQuery(this).parent().parent();
      var url   = jQuery(this).attr("href");
      deleteEntry(entry, url, {
        title  : "Löschen bestätigen...",
        message: "Soll das Buch aus der Liste gelöscht werden? Wenn Sie diese Aktion bestätigen wird das Buch ebenfalls aus dem Regal in der Bibliothek entfernt und in den normalen Bestand aufgenommen."
      });
    });

    /** If the user clicks the delete link of an media entry */
    jQuery(".delete-media-entry-action").live('click', function(event) {
      event.preventDefault();
      var entry = jQuery(this).parent().parent();
      var url   = jQuery(this).attr("href");
      deleteEntry(entry, url, {
        title  : "Löschen bestätigen...",
        message: "Soll der Eintrag wirklich gelöscht werden?"
      });
    });

    /** If the user clicks the edit link of an media entry */
    jQuery(".edit-media-entry-action").live('click', function(event) {
      event.preventDefault();
      var entry = jQuery(this).parent().parent();
      var url = jQuery(this).attr("href");
      editEntry(entry, url);
    });

    /** If the user clicks the create entry link of an entry */
    jQuery(".new-media-entry-action").change(function(event) {
      event.preventDefault();

      var entry_type = jQuery(this).attr('value');
      createEntry(entry_type);

      this.selectedIndex = 0;
    });

    /** Make media entries sortable with the mouse */
    jQuery("#sem-app-media-entries").sortable({
      items: '.sem-app-entry',
      handle: '.reorder-media-entry-action',
      update: function(event, ui) {
        reorderMediaEntries();
      }
    })

  });

})(jQuery)