/*
 * Module: Ajax Request
 */

var asynchronous = (function () {
    // Module variables
    var message = {
            error: {
                es: "Oops!, ha ocurrido un error, la operación no pudo completarse. Intentelo de nuevo, en caso de que el error " +
                "persista valide la conectevidad de su equipo, si no presenta fallas favor comuniquese con nosotros."
            },
            success: {
                es: "La solicitud se proceso correctamente."
            },
            warning: {
                es: "Alto!, se presento una novedad controlada, favor verificar la acción realizada."
            }
        },
        // Full screen div to indicate loading an ajax request
        div_loading = function loading_elements(title) {
            var html = '<div class="loading-fullscreen">' +
                '<div class="center-vertical">' +
                '<div class="text-center">' +
                '<h1 class="text-white">' + title + '</h1>' +
                '</div>' +
                '<div class="sk-spinner sk-spinner-three-bounce">' +
                '<div class="sk-bounce1"></div>' +
                '<div class="sk-bounce2"></div>' +
                '<div class="sk-bounce3"></div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $("body").append(html);
        },
        // Remove Div full screen to indicate loading an ajax request
        remove_div_loading = function remove_loading() {
            $("body").remove(".loading-fullscreen");
        },
        // Div to block a section within the page with an ajax call
        gift_sending_information = function sending_information(element) {
            var html = '<div class="loading-fullscreen">' +
                '<div class="center-vertical">' +
                '<div class="sk-spinner sk-spinner-rotating-plane"></div>' +
                '</div>' +
                '</div>';
            element.parent().append(html);
        },
        // Remove Div to block a section within the page with an ajax call
        remove_gift_sending_information = function remove_gift_sending(element) {
            element.parent().remove(".loading-fullscreen");
        }

    // Customize messages
    function customize_messages(custom_messages) {
        return custom_messages || message;
    }

    // Default message error
    function message_error(xhr, exception, status, messages) {
        /*percToastr.showToast({
            shortCutFunction: 'error',
            msg: messages.error[document.documentElement.lang]
        });*/
        console.log(xhr);
        console.log(exception);
        console.log(status);
    }

    // Default message success
    function message_success(data, messages) {
        return function (data, messages) {
            percToastr.showToast({
                shortCutFunction: 'success',
                msg: messages.success[document.documentElement.lang]
            });
            console.log('entro al succcess');
        }
    }

    // Configuring ajax call options
    function init_settings(variable_settings, messages, element) {
        var final_messages = customize_messages(messages),
            reload_page = variable_settings.reload || false;

        return {
            url: variable_settings.url || '',
            type: variable_settings.type || 'GET',
            dataType: variable_settings.dataType || 'json',
            data: variable_settings.data || {},
            contentType: variable_settings.contentType || 'script',
            beforeSend: variable_settings.beforeSend || function(){},
            success: variable_settings.success || function (info_response) {
                percToastr.showToast({
                    shortCutFunction: 'success',
                    msg: final_messages.success[document.documentElement.lang]
                });
                if (reload_page) {
                    if (variable_settings.href) {
                        window.location.href = variable_settings.href;
                    } else {
                        window.location.reload();    
                    }                    
                }
            },
            error: variable_settings.error || function (xhr, exception, status) {
                remove_div_loading();
                remove_gift_sending_information(element);
                console.log(xhr);
                console.log(exception);
                console.log(status);
                percToastr.showToast({
                    shortCutFunction: 'error',
                    msg: final_messages.error[document.documentElement.lang]
                });
            },
            complete: variable_settings.complete || function () { }
        };
    }

    // Public function for executing the ajax request
    var execute_ajax = function request_ajax(variable_settings, messages) {
        var array_ajax = init_settings(variable_settings, messages);
        //console.log(array_ajax);
        $.ajax(array_ajax);
    }

    // Definition of variables and public functions
    return {
        exec_ajax: execute_ajax,
        div_loading: div_loading,
        remove_loading: remove_div_loading,
        gift_send_info: gift_sending_information,
        remove_gift_send: remove_gift_sending_information
    }

})();