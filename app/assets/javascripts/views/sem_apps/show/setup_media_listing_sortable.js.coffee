#= require media/reorder
#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.setupMediaListingSortable', ->
  $("#media-listing").sortable
    items: '.item',
    handle: '.reorder-media-action',
    scrollSpeed: 10,
    helper: 'clone',
    start: ->
      $.frozen = true
      return true
    stop: ->
      $.frozen = false
      return true
    update: (event, ui) ->
      url = ui.item.find(".reorder-media-action").attr("href")
      app.media.reorder(url)
      return true
