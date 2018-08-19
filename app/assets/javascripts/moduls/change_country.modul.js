$(function () {
    // Actions on element with id change_country to send the change of country
    $("#change_country").change(function () {
        $.ajax({
            url: '/change/country',
            type: "GET",
            dataType: "json",
            data: {country_id: $("#change_country option:selected").val()},
            contentType: "script",
            success: function(data) {
                percToastr.showToast({
                    shortCutFunction: 'success',
                    msg: data
                });
                window.location.reload();
            },
            error: function(xhr,exception,status) {
                percToastr.showToast({
                    shortCutFunction: 'warning',
                    msg: exception
                });
            }
        });
    });
});