
class LoungesRepository
  def fetch()
    raise NoMethodError.new(not_implemented_error)
  end

  private

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end

class MemoryLoungesRepository < LoungesRepository
  
  def initialize()
    @lounge_list = []
  end

  def fetch()
    
  end
end
