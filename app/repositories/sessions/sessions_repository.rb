class SessionsRepository < ApplicationRepository
  def fetch_session(session_id)
    raise NoMethodError.new(not_implemented_error)
  end

  def create(session)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemorySessionsRepository < SessionsRepository
  @@initialized = false
  
  def initialize()
    super
    return if @@initialized

    @@sessions = {}
    @@initialized = true
  end

  def fetch_by_id(session_id)
    return @@sessions[session_id] if @@sessions.key?(session_id)
    raise NotFoundError.new("No session found with ID #{session_id}")
  end

  def create(session)
    @@sessions[session.id] = session
  end
end

class MemorySessionsRepositoryFactory
  def self.create_sessions_repository
    MemorySessionsRepository.new
  end
end

