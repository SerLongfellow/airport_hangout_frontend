

class ApplicationRepository
  require_relative '../errors/application_errors'

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end
