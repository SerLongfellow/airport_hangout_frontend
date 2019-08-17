require 'repositories/patrons/patrons_repository'
require 'repositories/users/users_repository'

class ConversationsRepository < ApplicationRepository
  def fetch_many(user_id)
    raise NoMethodError.new(not_implemented_error)
  end
  
  def fetch_by_id(conversation_id)
    raise NoMethodError.new(not_implemented_error)
  end
  
end

class MemoryConversationsRepository < ConversationsRepository
  require 'securerandom'

  @@initialized = false

  def initialize
    super
    return if @@initialized

    @@convos = {}

    @@initialized = true
  end
  
  def fetch_many(user_id)
    c = @@convos.select { |id, convo| convo.sender_id == user_id || convo.recipient_id == user_id }
    return c.map { |id, convo| convo }
  end

  def fetch_by_participant_ids(user_id, patron_id)
    @@convos.each do |id, convo|
      if (convo.sender_id == user_id && convo.recipient_id == patron_id) || \
         (convo.recipient_id == user_id && convo.sender_id == patron_id)
        return convo
      end
    end

    raise NotFoundError.new("No conversation found with any combination of IDs #{user_id} and #{patron_id}")
  end

  def fetch_by_id(conversation_id)
    return @@convos[conversation_id] if @@convos.key?(conversation_id)
    raise NotFoundError.new("No conversation found with ID #{conversation_id}")
  end

  def create!(conversation)
    id = SecureRandom.uuid
    conversation.id = id
    @@convos[id] = conversation
    
    return conversation
  end
  
  def append_message!(conversation, message)
    id = conversation.id

    raise NotFoundError.new("No conversation found with ID #{id}") if !@@convos.key?(id)
    conversation = @@convos[id]
    conversation.messages.append(message)
    @@convos[id] = conversation
    
    return conversation
  end
end
