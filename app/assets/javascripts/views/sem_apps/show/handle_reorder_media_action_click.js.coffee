#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleReordermediaActionClick', ->
  $('body').on 'click', '.reorder-media-action', (event) ->
    event.preventDefault()
