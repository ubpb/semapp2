#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleNewmediaPanelClick', ->
  $('body').on 'click', '#new-media-panel .close', (event) ->
    $('#new-media-panel').overlay().close()
