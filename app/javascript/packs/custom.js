$(document).on('turbolinks:load', function() {
    setTimeout(function () {
        $("#loader").fadeOut();
    }, 3000);
});