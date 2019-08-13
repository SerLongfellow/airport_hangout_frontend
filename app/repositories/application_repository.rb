
module RepositoryErrors
    class NotFoundError < StandardError

    end
end

class ApplicationRepository
  include RepositoryErrors

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end
