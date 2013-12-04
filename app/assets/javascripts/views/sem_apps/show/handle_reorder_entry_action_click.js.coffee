#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleReorderEntryActionClick', ->
  $('body').on 'click', '.reorder-entry-action', (event) ->
    event.preventDefault()
