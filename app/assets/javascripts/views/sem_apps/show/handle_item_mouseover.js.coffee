#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.handleItemMouseout', ->
  $('body').on 'mouseout', '.item', (event) ->
    target = $(@)
    target.item_unhighlight()
    target.item_toolbar_hide()
