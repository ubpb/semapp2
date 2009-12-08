(function($) {

  $(function() {

    /***********************************************************************************
     * API
     **********************************************************************************/

    function createEntry(item, url) {
      loadEditorPanel(item, url, {
        heading: "Einen neuen Eintrag erstellen"
      });
    }

    function editEntry(item, url) {
      loadEditorPanel(item, url);
    }

    function deleteEntry(item, url) {
      $.ajax({
        type: "delete",
        data: "_method=delete",
        async: true,
        url: url,
        success: function() {
          item.slideUp(500);
        }
      });
    }

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
     * Helper
     **********************************************************************************/

    function loadEditorPanel(item, url, options) {
      var options = jQuery.extend({
        heading: "Eintrag bearbeiten"
      }, options);

      // Store in a global context because we use
      // a single overlay instance.
      $.editor_current_heading = options.heading;
      $.editor_current_item = item;
      $.editor_current_url  = url;

      // Create the overlay
      $('#entry-editor-panel').overlay({
        oneInstance: true,
        closeOnClick: false,
        api: true,
        expose: {
          color: '#333',
          loadSpeed: 550,
          opacity: 0.6
        },
        onBeforeLoad: function() {
          this.getContent().find(".heading").html($.editor_current_heading);
          this.getContent().find(".content").html(loadPartial($.editor_current_url));
          ajaxifyEditorForm();
        //loadMCE();
        },
        onClose: function() {
          this.getContent().find(".heading").html("");
          this.getContent().find(".content").html("");
          $.editor_current_item = null;
          $.editor_current_url  = null;
        }
      }).load();
    }

    function closeEditorPanel() {
      $('#entry-editor-panel').overlay().close();
    }

    function loadPartial(url) {
      var content = null;
      $.ajax({
        type: "get",
        dataType: "json",
        async: false,
        url: url,
        success: function(data) {
          content = $('<div/>').html(data.partial).html();
        }
      });

      return content;
    }

    function ajaxifyEditorForm() {
      $("#entry-editor-panel .ajax-form").ajaxForm({
        dataType: 'json',
        success: function(data) {
          handleFormResponse(data);
        },
        beforeSubmit: function() {
        //if (typeof tinyMCE != 'undefined') {
        //  tinyMCE.triggerSave(true, true);
        //}
        }
      });
    }

    function handleFormResponse(data) {
      var content = $('<div/>').html(data.partial).html();
      var item    = $.editor_current_item

      if (data.result == 'success') {
        if (data.type == "create") {
          item.after(content);
          $('#no-entries-message').remove();
          $('#dummy-entry').remove();
          // We have created a new element, lets rebind some events
          rebindDropDownMenu();
        } else {
          item.find(".entry").html(content);
          item.effect("highlight", {}, 1000);
        }

        closeEditorPanel();
      } else {
        $('#entry-editor-panel .content').html(content);
        ajaxifyEditorForm();
      //loadMCE();
      }
    }

    function loadMCE() {
      $('#entry-editor-panel textarea.mce').tinymce({
        script_url: '/javascripts/tiny_mce/tiny_mce.js',
        theme: "advanced",
        add_form_submit_trigger: false,

        content_css: '/stylesheets/page.css',

        theme_advanced_toolbar_align: "left",
        theme_advanced_toolbar_location: "top",
        theme_advanced_statusbar_location: "bottom",
        theme_advanced_resizing: true
      });
    }

    function rebindDropDownMenu() {
      $('.dropdown li.trigger').unbind("click");
      $('.dropdown li.trigger').unbind("mouseleave");

      $('.dropdown li.trigger').bind("click", function() {
        jQuery('ul', this).css('display', 'block');
      });

      $('.dropdown li.trigger').bind("mouseleave", function() {
        jQuery('ul', this).css('display', 'none');
      });
    }

    /***********************************************************************************
     * Event hooks
     **********************************************************************************/

    /** If the user clicks the link to create a new antry */
    $(".create-entry-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      createEntry(item, url);
    });

    /** If the user clicks the link to create a new antry */
    $(".edit-entry-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      editEntry(item, url);
    });

    /** If the user clicks the link to delete an antry */
    $(".delete-entry-action").live('click', function(event) {
      event.preventDefault();
      var item = $(this).closest(".item");
      var url  = $(this).attr("href");

      var ret = confirm("Soll der Eintrag wirklich aus der Liste gelöscht werden? Diese Aktion kann nicht Rückgängig gemacht werden.");
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
    })

    /** (re)bind entry type dropdowns */
    rebindDropDownMenu();

  });

})(jQuery)