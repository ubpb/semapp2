#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleNewEntryPanelClick', ->
  $('body').on 'click', '#new-entry-panel .close', (event) ->
    $('#new-entry-panel').overlay().close()
