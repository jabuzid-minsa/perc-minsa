/*
 * Module: Grouping for setting the call to datepicker elements
 */

var datepicker_settings = (function () {

    // Configuring datepicker options
    function init_settings(variable_settings) {
        variable_settings = variable_settings || {};
        return {
            format: variable_settings.format || 'mm-yyyy',
            startView: variable_settings.startView || 'months',
            minViewMode: variable_settings.minViewMode || 'months',
            autoclose: variable_settings.autoclose || true
        };
    }

    // Public function for executing the ajax request
    var datepicker_configuration = function datepicker_configuration(element, variable_settings) {
        element = element || '.input-group.date';
        $(element).datepicker(
            init_settings(variable_settings)
        );
    }

    return {
        datepicker_config: datepicker_configuration
    }
})();