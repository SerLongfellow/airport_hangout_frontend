
require 'errors/application_errors'
require 'repositories/sessions/sessions_repository'

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private

    def find_user
      begin
        session_id = cookies.encrypted[:session_id]
        reject_unauthorized_connection if session_id.nil?
        
        sessions_repo = MemorySessionsRepositoryFactory.create_sessions_repository
        user = sessions_repo.fetch_by_id(session_id).current_user
        return user
      rescue NotFoundError => e
        reject_unauthorized_connection
      end
    end
  end
end
