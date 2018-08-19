/**
 * Modul for alerts with Toastr plugin
 *
 */
var percToastr = (function () {

    var initializeToast = function (options) {
        // Creation and validation of necessary variables.
        var shortCutFunction = options.shortCutFunction,
            msg = options.msg,
            title = options.title || "",
            showDuration = options.showDuration || "400",
            hideDuration = options.hideDuration || "400",
            timeOut = options.timeOut || "7000",
            extendedTimeOut = options.extendedTimeOut || "3000",
            showEasing = options.showEasing || "swing",
            hideEasing = options.hideEasing || "linear",
            showMethod = options.showMethod || "fadeIn",
            hideMethod = options.hideMethod || "fadeOut",
            toastIndex = options.toastCount++ || 0;

        // Object creation for the alert.
        toastr.options = {
            closeButton: options.closeButton || true,
            debug: options.debug || false,
            progressBar: options.progressBar || true,
            preventDuplicates: options.preventDuplicates || true,
            positionClass: options.positionClass || 'toast-top-right',
            onclick: null,
            onHidden: function() { $(".alert, .notice").val(""); },
            showDuration: showDuration,
            hideDuration: hideDuration,
            timeOut: timeOut,
            extendedTimeOut: extendedTimeOut,
            showEasing: showEasing,
            hideEasing: hideEasing,
            showMethod: showMethod,
            hideMethod: hideMethod
        };

        // Validation if you want reload the page.
        if (options.realoadPage) {
            toastr.options.onHidden = function () {
                $(".alert, .notice").val("");
                if (options.reloadLocation) {
                    window.location = options.reloadLocation;
                } else {
                    window.location.reload();
                }
            };
        }

        // Called Alert.
        var $toast = toastr[shortCutFunction](msg, title);
    };

    var showToast = function (options) {
        initializeToast(options);
    };

    var show_alerts_or_notice = function show_messages() {
        if ($(".alert").html() != "" || $(".notice").html() != "") {
            percToastr.showToast({
                shortCutFunction: $(".alert").html() != "" ? 'warning' : 'success',
                msg: $(".alert").html() != "" ? $(".alert").html() : $(".notice").html()
            });
        }
    }

    return {
        showToast: showToast,
        val_backend_messages: show_alerts_or_notice
    };

})();