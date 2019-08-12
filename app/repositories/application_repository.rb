
class ApplicationRepository
  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end
