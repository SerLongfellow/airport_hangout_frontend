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

    $(document).ready(function() {
      $("#messages").append(message);
    });

  },

  broadcast: function(message) {
    var conversationId = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
    this.perform("broadcast", {"text": message, "conversationId": conversationId});
  }
});
