#= require utils/singletonReadyOrPageChange
#= require markitup/sets/textile/set

app.utils.singletonReadyOrPageChange 'app.views.application.enableTextile', ->
  $('.textile').markItUp(markItUpTextileSettings)
