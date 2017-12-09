//= require jquery
//= require cable

var $update_status, $status_msg;
$(document).ready(function () {
    $update_status = $('.update-status');
    $status_msg = $('.status-msg');
    var $query_ip = $('#query-ip');

    $('#upload-submit').click(function (e) {
        e.preventDefault();
        $(this).prop('disabled', true);

        $update_status.text('Uploading the file ...');
        $('.csv-upload-btn-wrapper form').submit();

        receiveBroadCast();
    });

    $('#query-btn').click(function (e) {
        e.stopImmediatePropagation();

        var inputs = parseInputsFromQuery($query_ip.val());

        if(inputs.object_type && inputs.object_id && inputs.timestamp) {
            getObjectStatus(inputs.object_type, inputs.object_id, inputs.timestamp);
        } else {
            $status_msg.text("Please provide the Query in a valid format. Ex: What's the state of Order Id=1 At timestamp=1484733173 ?");
        }
    });
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

function parseInputsFromQuery(query_string) {
    var inputs = {};

    var id_result = query_string.match(/id=\d+/i);
    if(id_result) {
        inputs['object_id'] = id_result[0].split('=')[1]
    }

    var timestamp_result = query_string.match(/timestamp=\d+/i);
    if(timestamp_result) {
        inputs['timestamp'] = timestamp_result[0].split('=')[1]
    }

    var object_type_result = query_string.match(/state of \w+/i);
    if(object_type_result) {
        inputs['object_type'] = object_type_result[0].split(' ')[2]
    }

    return inputs;
}

function getObjectStatus(object_type, object_id, timestamp) {
    $.ajax({
        url: object_status_url,
        method: 'GET',
        data: { object_type: object_type, object_id: object_id, timestamp: timestamp },
        success: function(result) {
            if(result.status) {
                $status_msg.text(result.object_changes);
            } else {
                $status_msg.text(result.message);
            }
        },
        failure: function () {
            $status_msg.text('Something went wrong! Please try again.');
        }
    });
}
