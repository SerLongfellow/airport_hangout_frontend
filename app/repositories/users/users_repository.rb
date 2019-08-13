
require 'repositories/application_repository'
require 'repositories/lounges/lounges_repository'


class UsersRepository < ApplicationRepository
  def fetch_user(user_id)
    raise NoMethodError.new(not_implemented_error)
  end
  
  def check_into_lounge(lounge, user)
    raise NoMethodError.new(not_implemented_error)
  end
end


class MemoryUsersRepository < UsersRepository
  @@initialized = false
  
  def initialize()
    super()
    return if @@initialized

    @@users = {}
    @@initialized = true
  end

  def fetch_user(user_id)
    user_id = user_id.to_s()

    if @@users.key?(user_id)
      return @@users[user_id]
    else
      raise RepositoryErrors::NotFoundError.new("No user found with ID " + user_id.to_s())
    end
  end
  
  def create_user(user)
    user.id = rand(5..1024).to_s()  # gen ID
    @@users[user.id] = user
    return user
  end
  
  def check_into_lounge(lounge, user)
    if @@users.key?(user.id)
      @@users[user.id].current_lounge = lounge
      return @@users[user.id]
    end
  end
end
