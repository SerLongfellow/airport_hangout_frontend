
class ConversationsRepository < ApplicationRepository
  def fetch_many(user_id, patron_id)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryConversationsRepository < ConversationsRepository
  def fetch_many(user_id, patron_id)
    messages =  []

    messages.push(Message.new("555", "If you're 555..."))
    messages.push(Message.new("666", "...then I'm 666!"))

    return messages
  end
end
