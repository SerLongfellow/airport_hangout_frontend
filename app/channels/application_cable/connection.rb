
require 'errors/application_errors'
require 'repositories/users/users_repository'

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private

    def find_user
      begin
        reject_unauthorized_connection if !cookies.key?(:current_user_id)
        
        users_repo = MemoryUsersRepository.new
        user_id = cookies.encrypted[:current_user_id].to_s
        user = users_repo.fetch_user(user_id)
        return user
      rescue NotFoundError => e
        reject_unauthorized_connection
      end
    end
  end
end
