//= require jquery

const TEXT_ID = "#new-message";
const BUTTON_ID = "#send-message-button";

var outstandingMessageId = "";

function disableButton(button) {
    button.prop('disabled', true);
}

function enableButton(button) {
    button.prop('disabled', false);
}

$(document).ready(function() {
    var button = $(BUTTON_ID);
    button.click(function() {
        App.chat.broadcast($("#new-message").val());
        $(TEXT_ID).val('');
    });
});

