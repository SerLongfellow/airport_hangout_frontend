
class LoungesRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end
  
  def fetch_by_id(id)
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

    airport = Airport.new(1, "SEA", "Seattle-Tacoma International Airport")
    
    lounge = Lounge.new(1, "Cool-Ass Playas Lounge", airport)
    @lounge_list.push(lounge)

    lounge = Lounge.new(2, "I Want My IPA Lounge", airport)
    @lounge_list.push(lounge)
    
    lounge = Lounge.new(3, "Delta Premium Lounge", airport)
    @lounge_list.push(lounge)
  end

  def fetch_many()
    return @lounge_list
  end
  
  def fetch_by_id(id)
    return @lounge_list[id.to_i - 1]
  end
end
