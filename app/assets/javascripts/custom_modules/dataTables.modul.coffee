window.incuboDataTables = do ->
  initialize_variables = (element, settings={}) ->
    variables =
      # Customizable Settings
      name_for_export: settings.name_for_export or get_name_for_export(element)

      # Plugin DataTables Settings
      aaSorting: settings.datatables.aaSorting or [[0, 'asc']]
      responsive: settings.datatables.responsive or true
      destroy: settings.datatables.destroy or true
      dom: settings.datatables.dom or '<"html5buttons"B>lTfgitp'
      lengthMenu: settings.datatables.lengthMenu or [10, 25, 50, 75, 100]
    return variables

  # Get columns exportable
  get_column_export = (element) ->
    cols = []
    $(element).find('thead th').each (k, v)->
      if !$(v).hasClass('non-exportable')
        cols.push k
      return
    return cols

  # Get name for export file
  get_name_for_export = (element) ->
    return $(element).data('name_export')

  # Get translation object
  get_i18n_texts = ->
    idiom =
      sProcessing: 'Procesando...'
      sLengthMenu: 'Mostrar _MENU_ registros'
      sZeroRecords: 'No se encontraron resultados'
      sEmptyTable: 'Ningún dato disponible en esta tabla'
      sInfo: 'Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros'
      sInfoEmpty: 'Mostrando registros del 0 al 0 de un total de 0 registros'
      sInfoFiltered: '(filtrado de un total de _MAX_ registros)'
      sInfoPostFix: ''
      sSearch: 'Buscar:'
      sUrl: ''
      sInfoThousands: ','
      sLoadingRecords: 'Cargando...'
      oPaginate:
        sFirst: 'Primero'
        sLast: 'Último'
        sNext: 'Siguiente'
        sPrevious: 'Anterior'
      oAria:
        sSortAscending: ': Activar para ordenar la columna de manera ascendente'
        sSortDescending: ': Activar para ordenar la columna de manera descendente'
      buttons:
        copyTitle: 'Copiar'
        copySuccess:
          _: '%d filas copiadas'
          1: '1 fila copiada'

    return idiom

  #
  arming_object_dataTables = (element, settings) ->
    export_columns = get_column_export(element)
    settings = initialize_variables(element, settings)
    object_dataTables =
      aaSorting: settings.aaSorting
      responsive: settings.responsive
      destroy: settings.destroy
      language: get_i18n_texts()
      dom: settings.dom
      buttons: [
        {
          extend: 'copy'
          exportOptions: columns: export_columns
        }
        {
          extend: 'csv'
          title: settings.name_for_export
          exportOptions: columns: export_columns
        }
        {
          extend: 'excel'
          title: settings.name_for_export
          exportOptions: columns: export_columns
        }
        {
          extend: 'pdf'
          title: settings.name_for_export
          exportOptions: columns: export_columns
        }
        {
          extend: 'print'
          customize: (win) ->
            $(win.document.body).addClass 'white-bg'
            $(win.document.body).css 'font-size', '10px'
            $(win.document.body).find('table').addClass('compact').css 'font-size', 'inherit'
            return
          exportOptions: columns: export_columns
        }
      ]
      lengthMenu: settings.lengthMenu
    return object_dataTables

  #
  create_filtering_fields_footer = (element, class_excluded='non-footFilt') ->
    $(element).find('tfoot th').each (k, v) ->
      if !$(v).hasClass(class_excluded)
        $(this).html '<input type="text" placeholder="' + $(this).text() + '" />'
      return
    return

  #
  action_search_fields_footer = (dataTable_element) ->
    dataTable_element.columns().every ->
      that = this
      $('input', this.footer()).on 'keyup change', ->
        if that.search() != this.value
          that.search(this.value).draw()
        return
      return
    return

  #
  initialize = (settings={datatables:{}}) ->
    # Variables
    element = settings.element or '.incuboDataTable'
    filter_footer = settings.datatables.filter_footer or false
    # Initialize dataTables
    dataTable_element = $(element).DataTable arming_object_dataTables(element, settings)

    if filter_footer
      # Create filter footer inputs
      create_filtering_fields_footer(element)
      # Activate functionaly filter footer
      action_search_fields_footer(dataTable_element)
    return

  #
  initialize_fixed = (settings={fixedDataTable:{}}) ->
    # Variables
    element = settings.element or '.incuboDataTableFixed'
    # Initialize dataTables
    $(element).DataTable
      bInfo: false
      searching: false
      bSort: false
      destroy: settings.fixedDataTable.destroy or true
      scrollY: settings.fixedDataTable.scrollY or '100%'
      scrollX: true
      scrollCollapse: true
      paging: false
      fixedColumns: leftColumns: settings.fixedDataTable.leftColumns or 1

  {
    constructDataTable: initialize
    constructDataTableFixed: initialize_fixed
  }