require 'securerandom'

class ConversationChannel < ApplicationCable::Channel
  
  def subscribed
    puts "subscribed!"
    stream_from "conversation_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def broadcast(data)

    puts "User ID: "
    puts "calling broadcast on connection " + ActionCable.server
    message = Message.new(SecureRandom.uuid, data["data"], "0", "")
    rendered = ApplicationController.render(:partial => "conversations/message", :locals => { :message => message })
    ActionCable.server.broadcast("conversation_channel", message: rendered)
  end
end
