#
# Deletes a book from the listing.
#
window.app       ?= {}
window.app.books ?= {}

window.app.books.delete = (item, url) ->
  item.slideUp(500)

  $.ajax
    type: "delete",
    data: "_method=delete",
    async: true,
    url: url,
    error: ->
      alert("Beim Versuch den Eintrag zu löschen ist ein Fehler aufgetreten. Laden Sie die Seite neu und versuchen Sie es erneut. Sollte es wiederholt zu einem Fehler kommen, kontaktieren Sie bitte den Support.")
