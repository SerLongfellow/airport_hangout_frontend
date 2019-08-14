App.chat = App.cable.subscriptions.create("ChatChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    console.log("We're connected!");
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    console.log("We're disconnected!");
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("We got a message! " + data);
  },

  broadcast: function(data) {
    console.log("Broadcasting data...");

    this.perform("broadcast", {"data": data});
  }
});
