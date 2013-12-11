#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.sem_apps.handleNewmediaActionClick.', ->
  $('body').on 'click', '.new-media-action', (event) ->
    event.preventDefault()
    url = $(@).attr("href")

    $.ajax
      url: url,
      dataType: "html",
      success: (data) ->
        $('#new-media-panel').html(data).append('<div class="close"></div>')
        $('#new-media-panel').overlay(
          expose:
            color: '#333',
            loadSpeed: 150,
            opacity: 0.6
          closeOnClick: false,
          api: true
        ).load()
      error: (request, settings, thrownError) ->
        tab.append( "<li>Error requesting page " + settings.url + ": " +
          thrownError + " in " + thrownError.fileName + ":" +
          thrownError.lineNumber + ":" + thrownError.columnNumber + ") </li>" )
