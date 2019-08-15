
class ConversationsRepository < ApplicationRepository
  def fetch_many(user_id, patron_id)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryConversationsRepository < ConversationsRepository
  require 'repositories/patrons/patrons_repository'
  require 'repositories/users/users_repository'

  def fetch_many(user_id, patron_id)
    messages =  []

    users_repo = MemoryUsersRepository.new
    user = users_repo.fetch_user(user_id)

    patrons_repo = MemoryPatronsRepository.new
    patron = patrons_repo.fetch_by_id(patron_id)

    messages.push(Message.new("555", "If you're 555...", user_id, user.name))
    messages.push(Message.new("666", "...then I'm 666!", patron_id, patron.name))

    return messages
  end
end
