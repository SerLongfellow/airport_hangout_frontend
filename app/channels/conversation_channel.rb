require 'securerandom'
require 'repositories/conversations/conversations_repository'
require 'repositories/users/users_repository'

class ConversationChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "conversation_channel_user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def broadcast(message)
    message_text = message['text']
    conversation_id = message['conversationId']

    conversations_repo = ConversationsRepositoryFactory.create_repository
    conversation = conversations_repo.fetch_by_id(conversation_id)  # fetch to make sure it exists

    message = Message.new(SecureRandom.uuid, conversation_id, message_text, current_user.id, current_user.name)
    conversation = conversations_repo.append_message!(conversation, message)

    # First, broadcast back to this user's connection
    rendered = ApplicationController.render(:partial => 'conversations/message', :locals => { :message => message, :current_user => current_user })
    ActionCable.server.broadcast("conversation_channel_user_#{current_user.id}", message: rendered)
    
    # Then, broadcast to the other conversation partner's connection
    users_repo = UsersRepositoryFactory.create_repository

    remote_party_id = conversation.recipient_id
    if remote_party_id == current_user.id
      remote_party_id = conversation.sender_id
    end

    recipient = users_repo.fetch_user(remote_party_id)
    
    rendered = ApplicationController.render(:partial => 'conversations/message', :locals => { :message => message, :current_user => recipient })
    ActionCable.server.broadcast("conversation_channel_user_#{recipient.id}", message: rendered)
  end
end
