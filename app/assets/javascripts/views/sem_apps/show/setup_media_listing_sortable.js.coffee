#= require entries/reorder
#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.setupMediaListingSortable', ->
  $('body').on 'media-tab-loaded', ->
    $("#media-listing").sortable
      items: '.item',
      handle: '.reorder-entry-action',
      scrollSpeed: 10,
      helper: 'clone',
      start: ->
        $.frozen = true
        return true
      stop: ->
        $.frozen = false
        return true
      update: (event, ui) ->
        url = ui.item.find(".reorder-entry-action").attr("href")
        app.entries.reorder(url)
        return true
