window.app         ?= {}
window.app.entries ?= {}

window.app.entries.reorder = (url) ->
  orderedList = $("#media-listing").sortable('serialize')

  $.ajax
    type: "put",
    data: "_method=put&" + orderedList,
    url: url
