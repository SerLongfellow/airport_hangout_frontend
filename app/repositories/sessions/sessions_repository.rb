
require 'repositories/application_repository'


class SessionsRepository < ApplicationRepository
  def fetch_session(session_id)
    raise NoMethodError.new(not_implemented_error)
  end
end


class MemorySessionsRepository < SessionsRepository
  @@initialized = false
  
  def initialize()
    super()

    if @@initialized
      return
    end

    @@sessions = {}
    @@initialized = true
  end

  def fetch_session(session_id)
    return @@sessions[session_id]
  end
end
