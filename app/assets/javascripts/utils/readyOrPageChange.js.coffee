window.app       ?= {}
window.app.utils ?= {}

window.app.utils.readyOrPageChange ?= (event_handler) =>
  $.ready.promise().done(event_handler)
  $(window).on('page:change', event_handler)
