class UsersRepository < ApplicationRepository
  include Singleton
  
  def fetch_user(user_id)
    raise NoMethodError.new(not_implemented_error)
  end
  
  def check_into_lounge(lounge, user)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryUsersRepository < UsersRepository

  @@initialized = false
  
  def initialize
    super
    return if @@initialized

    puts("Initializing users repo")

    @@users = {}
    @@users["1"] = User.new("1", "Billy Bob", "Little Rock, AR", "1")
    @@users["2"] = User.new("2", "Foo Bar", "Seattle, WA", "1")
    @@initialized = true
  end

  def fetch_user(user_id)
    user_id = user_id.to_s()

    if @@users.key?(user_id)
      return @@users[user_id]
    else
      raise NotFoundError.new("No user found with ID " + user_id.to_s())
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

class MemoryUsersRepositoryFactory
  def self.create_users_repository
    MemoryUsersRepository.instance
  end
end
