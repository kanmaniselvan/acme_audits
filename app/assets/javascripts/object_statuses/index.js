//= require jquery
//= require cable

var $update_status;
$(document).ready(function () {
    $update_status = $('.update-status');

    $('#upload-submit').click(function (e) {
        e.preventDefault();

        $update_status.text('Uploading the file ...');
        $('.csv-upload-btn-wrapper form').submit();

        receiveBroadCast();
    })
});

function receiveBroadCast(){
    App.cable.subscriptions.create(
        {
            channel: 'CsvImportStatusChannel'
        },
        {
            received: function(data) {
                $update_status.text(data.message);
            }
        }
    );
}
