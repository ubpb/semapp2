window.app         ?= {}
window.app.entries ?= {}

window.app.entries.delete = (item, url) ->
  item.slideUp(500)

  $.ajax
    type: "delete",
    data: "_method=delete",
    url: url
