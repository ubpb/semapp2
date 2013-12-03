#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.handleItemMouseover', ->
  $('body').on 'mouseover', '.item', (event) ->
    target = $(@)

    unless target.hasClass('no-hover')
      target.item_highlight()
      target.item_toolbar_show()
