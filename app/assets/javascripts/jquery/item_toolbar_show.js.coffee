#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.jquery.itemToolbarShow', ->
  $.fn.item_toolbar_show = ->
    unless ($.frozen == true)
      @find(".toolbar-wrapper").show()
      @find(".toolbar").show()

    return @
