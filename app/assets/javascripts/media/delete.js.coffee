window.app         ?= {}
window.app.media ?= {}

window.app.media.delete = (item, url) ->
  item.slideUp(500)

  $.ajax
    type: "delete",
    data: "_method=delete",
    url: url
