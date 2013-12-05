#= require utils/singletonReadyOrPageChange

app.utils.singletonReadyOrPageChange 'app.views.admin.application.handlePrintClick', ->
  $(".print").live 'click', (e) ->
    e.preventDefault()

    # remove old printframe
    $("#printframe").remove()

    # create new printframe
    (iFrame = $('<iframe></iframe>'))
      .attr("id", "printframe")
      .attr("name", "printframe")
      .attr("src", "about:blank")
      .css("width", "0")
      .css("height", "0")
      .css("position", "absolute")
      .css("left", "-9999px")
      .appendTo($("body:first"))

    # load printframe
    url = $(@).attr("href")
    if (iFrame != null && url != null)
      iFrame.attr('src', url)
      iFrame.load ->
        # nasty hack to be able to print the frame
        tempFrame = $('#printframe')[0]
        tempFrameWindow = if tempFrame.contentWindow? then tempFrame.contentWindow else tempFrame.contentDocument.defaultView
        tempFrameWindow.focus()
        tempFrameWindow.print()
