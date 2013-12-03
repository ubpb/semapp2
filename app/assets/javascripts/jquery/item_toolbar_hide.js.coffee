#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.jquery.itemToolbarHide', ->
  $.fn.item_toolbar_hide = ->
    unless $.frozen == true
      this.find(".toolbar-wrapper").hide()
      this.find(".toolbar").hide()
    
    return @
