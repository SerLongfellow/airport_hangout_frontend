App.chat = App.cable.subscriptions.create("ConversationChannel", {
    connected: function() {
        // Called when the subscription is ready for use on the server
        console.log("We're connected!");
    },

    disconnected: function() {
        // Called when the subscription has been terminated by the server
        console.log("We're disconnected!");
    },

    received: function(data) {
        message = data["message"]
        console.log("Got message: " + message);

        convoId = $(message).data("convo-id");

        $(document).ready(function() {
            if (onConversationPage(convoId)) {
                appendMessage(message);
            } else {
                notifyNewMessage();
            }
        });

    },

    broadcast: function(message) {
        var conversationId = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
        this.perform("broadcast", {"text": message, "conversationId": conversationId});
    }
});
