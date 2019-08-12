
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

    if @@initialized
      return
    end

    @@users = {}
    @@initialized = true
  end

  def fetch_user(user_id)
    if @@users.key?(user_id)
      return @@users[user_id]
    else
      puts "Creating new user..."
      user = User.new(user_id, "Jeff Long", "Maynard, AR")
#      user = User.new(user_id)
      @@users[user_id] = user
      return user
    end

  end
  
  def check_into_lounge(lounge, user)
    if @@users.key?(user.id)
      @@users[user.id].current_lounge = lounge
      return @@users[user.id]
    end
  end
end
