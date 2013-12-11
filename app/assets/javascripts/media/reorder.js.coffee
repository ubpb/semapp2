window.app         ?= {}
window.app.media ?= {}

window.app.media.reorder = (url) ->
  orderedList = $("#media-listing").sortable('serialize')

  $.ajax
    type: "put",
    data: "_method=put&" + orderedList,
    url: url
