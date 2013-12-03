#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.handleItemMouseout', ->
  $('body').on 'mouseout', '.item', (event) ->
    target = $(@)
    target.item_unhighlight()
    target.item_toolbar_hide()
