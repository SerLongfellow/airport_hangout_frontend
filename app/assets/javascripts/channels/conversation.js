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
    console.log("Got message: " + data["message"]);
    $(document).ready(function() {
      $("#messages").append(data["message"]);
    });

  },

  broadcast: function(data) {
    console.log("Broadcasting data...");

    this.perform("broadcast", {"data": data});
  }
});
