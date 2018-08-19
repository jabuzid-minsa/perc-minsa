var perc_data_tables = (function () {
    // Function to validate number of columns for table.
    function size_reduction_validate_columns(columns_visible_actions, size_columns) {
        var new_size_columns = size_columns;
        if (columns_visible_actions == true) {
            new_size_columns = new_size_columns - 1;
        }
        return new_size_columns;
    }

    function variable_array_for_columns(array_size) {
        var variable_array = [];
        for (i = 0; i <= array_size; ++i) {
            variable_array.push(i);
        }
        return variable_array;
    }

    function filters_by_columns(columns_visible_actions) {
        var size_columns = size_reduction_validate_columns(
            columns_visible_actions,
            $('.list_of_model_elements tfoot th').length
        );
        $(".list_of_model_elements tfoot th").each(function (index, element) {
            if(index < size_columns) {
                var title = $(this).text();
                $(this).html( '<input type="text" placeholder="'+title+'" />' );
            }
        });
    }

    function footer_search(table) {
        table.columns().every( function () {
            var that = this;
            $( 'input', this.footer() ).on( 'keyup change', function() {
                if ( that.search() !== this.value ) {
                    that.search( this.value )
                        .draw();
                }
            });
        });
    }

    function data_datatable(size_columns, name_export, aasort, texts_i18n) {

        return {
            aaSorting: aasort,
            responsive: true,
            "language": {
                "sProcessing":     texts_i18n.language.processing,
                "sLengthMenu":     texts_i18n.language.length_menu,
                "sZeroRecords":    texts_i18n.language.zero_records,
                "sEmptyTable":     texts_i18n.language.empty_table,
                "sInfo":           texts_i18n.language.info,
                "sInfoEmpty":      texts_i18n.language.info_empty,
                "sInfoFiltered":   texts_i18n.language.info_filtered,
                "sInfoPostFix":    "",
                "sSearch":         texts_i18n.language.search,
                "sUrl":            "",
                "sInfoThousands":  ",",
                "sLoadingRecords": texts_i18n.language.loading_records,
                "oPaginate": {
                    "sFirst":    texts_i18n.language.paginate.first,
                    "sLast":     texts_i18n.language.paginate.last,
                    "sNext":     texts_i18n.language.paginate.next,
                    "sPrevious": texts_i18n.language.paginate.previous
                },
                "oAria": {
                    "sSortAscending":  texts_i18n.language.sort_ascending,
                    "sSortDescending": texts_i18n.language.sort_descending
                },
                "buttons": {
                    copyTitle: texts_i18n.language.copy_text.title,
                    copySuccess: {
                        _: texts_i18n.language.copy_text.success.other,
                        1: texts_i18n.language.copy_text.success.one
                    }
                }
            },
            dom: '<"html5buttons"B>lTfgitp',
            buttons: [
                {
                    extend: 'copy',
                    text: texts_i18n.language.buttons.copy,
                    exportOptions: {columns: variable_array_for_columns(size_columns) }
                },
                {
                    extend: 'csv',
                    exportOptions: {columns: variable_array_for_columns(size_columns) }
                },
                {
                    extend: 'excel',
                    title: name_export,
                    exportOptions: {columns: variable_array_for_columns(size_columns) }
                },
                {
                    extend: 'pdf',
                    title: name_export,
                    exportOptions: {columns: variable_array_for_columns(size_columns) }
                },
                {
                    extend: 'print',
                    customize: function (win){
                        $(win.document.body).addClass('white-bg');
                        $(win.document.body).css('font-size', '10px');
                        $(win.document.body).find('table')
                            .addClass('compact')
                            .css('font-size', 'inherit');
                    },
                    exportOptions: {columns: variable_array_for_columns(size_columns) },
                    text: texts_i18n.language.buttons.print
                }
            ],
            lengthMenu: [ 100, 25, 50, 75 ]
        };
    }

    var initialize = function initialize_datatable(size_columns, name_export, aasort, visible_actions, texts_i18n) {
        filters_by_columns(visible_actions);
        var new_size_columns = size_reduction_validate_columns(visible_actions, size_columns);
        var table = $('.list_of_model_elements').DataTable(
            data_datatable(new_size_columns, name_export, aasort, texts_i18n)
        );
        footer_search(table);
    }

    return {
        construct_datatable: initialize
    }

})();