#= require utils/singletonReadyOrPageChange
#= require books/delete

app.utils.singletonReadyOrPageChange 'app.books.handleDeleteBookActionClick', ->
  # If the user clicks the link to delete a book
  $('body').on 'click', '.delete-book-action', (event) ->
    event.preventDefault()
    item = $(@).closest(".item")
    url  = $(@).attr("href")

    ret = confirm("Soll das Buch wirklich aus der Liste gelöscht werden? Wenn Sie diese Aktion bestätigen wird das Buch ebenfalls aus dem Regal in der Bibliothek entfernt und in den normalen Bestand aufgenommen.")
    app.books.delete(item, url) if ret == true
