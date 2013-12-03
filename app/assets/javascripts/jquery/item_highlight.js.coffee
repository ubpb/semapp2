#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.jquery.itemHighlight', ->
  $.fn.item_highlight = ->
    @addClass("highlight") unless $.frozen == true
    return @
