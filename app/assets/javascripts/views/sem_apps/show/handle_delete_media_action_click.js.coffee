#= require media/delete
#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.show.handleDeletemediaActionClick', ->
  $('body').on 'click', '.delete-media-action', (event) ->
    event.preventDefault()
    target = $(@)
    item = target.closest(".item")
    url  = target.attr("href")

    ret = confirm("Eintrag wirklich löschen?")
    app.media.delete(item, url) if ret is true
