window.datepicker_modul = do ->
  # Settings Plugin
  initializeDatepicker = (options)->
    {
      format: options.format || 'mm-yyyy'
      startView: options.startView || 'months'
      minViewMode: options.minViewMode || 'months'
      autoclose: options.autoclose || true
    }

  # Ge
  generateDatepicker = (options={})->
    element = options.element || '.input-group.date'
    $(element).datepicker(initializeDatepicker(options))

  {
    create_datepicker: generateDatepicker
  }