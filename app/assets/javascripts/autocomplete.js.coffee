app.utils.singletonReadyOrPageChange 'app.autocomplete', ->

  input   = $('form input[type="text"][data-autocomplete]')
  source  = input.data('autocomplete-source')
  idField = input.data('autocomplete-id-field')

  input.autocomplete
    source: source
    focus: (event, ui) ->
      label = ui.item.label
      $(this).val(label)
      return false

    select: (event, ui) ->
      label = ui.item.label
      value = ui.item.value

      $(this).val(label)
      $(idField).val(value)
      return false
