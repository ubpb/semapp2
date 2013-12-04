#= require entries/delete
#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleDeleteEntryActionClick', ->
  $('body').on 'click', '.delete-entry-action', (event) ->
    event.preventDefault()
    target = $(@)
    item = target.closest(".item")
    url  = target.attr("href")

    ret = confirm("Eintrag wirklich löschen?")
    app.entries.delete(item, url) if ret is true
