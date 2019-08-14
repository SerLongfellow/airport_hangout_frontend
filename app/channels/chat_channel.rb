class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
    puts "Channel streaming"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "Channel cleanup"
  end

  def broadcast(message)
    puts "Broadcasting message: " + message.to_s
    ActionCable.server.broadcast("chat_channel", message: message["data"])
  end
end
