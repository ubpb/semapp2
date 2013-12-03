#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.jquery.itemUnhighlight', ->
  $.fn.item_unhighlight = ->
    @removeClass("highlight") unless $.frozen == true
    return @
