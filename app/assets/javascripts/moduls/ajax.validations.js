var validation_ajax_code = (function () {
    //
    function armed_message_error(error) {
        var msg = "<ul>";
        $.each(xhr.responseJSON, function (index, value) {
            msg += "<li>"+value+"</li>";
        });
        msg += "</ul>";
        return msg;
    }

    //
    var validate_code = function validation_ajax(parameters, dom_element) {
        $.ajax({
            url: parameters.url,
            type: "GET",
            dataType: "json",
            data: parameters.parameters,
            contentType: "script",
            success: function(data) {
                if (data == false){
                    dom_element.val("");
                    dom_element.focus();
                    percToastr.showToast({
                        shortCutFunction: 'warning',
                        msg: parameters.message
                    });
                }
            },
            error: function(xhr,exception,status) {
                percToastr.showToast({
                    shortCutFunction: 'warning',
                    msg: armed_message_error(xhr)
                });
            }
        });
    }
    
    return {
        validate_code: validate_code
    };
})();