var perc_sweet_alert = (function () {

    var initializeAlert = function (options) {
        var url = options.url || '',
            href = options.href || '',
            closeOnConfirm = options.closeOnConfirm || false,
            confirmButtonColor = options.confirmButtonColor ||  "#DD6B55",
            confirmButtonText = options.confirmButtonText ||  'Si, estoy seguro!',
            html = options.html ||  true,
            title = options.title ||  "Esta Seguro?",
            text = options.text ||  "Se inactivara el elemento seleccionado, si desea proceder con la acción<span class='text-info'>presione el botón rojo!</span>",
            type = options.type ||  "warning",
            showCancelButton = options.showCancelButton ||  true;
    };

    var sweet_alert = function (options) {
        initializeAlert(options);
    };

    return {
        sweet_alert: sweet_alert
    };
})();