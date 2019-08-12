
require 'repositories/application_repository'


class LoungesRepository < ApplicationRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end
  
  def fetch_by_id(id)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryLoungesRepository < LoungesRepository
  
  def initialize()
    @lounge_list = []

    airport = Airport.new(1, "SEA", "Seattle-Tacoma International Airport")
    
    lounge = Lounge.new(1, "Cool-Ass Playas Lounge", airport, description="Where all the cool kids come to play...", number_of_patrons=2)
    @lounge_list.push(lounge)

    lounge = Lounge.new(2, "I Want My IPA Lounge", airport, description="Over 9,000 IBU's!")
    @lounge_list.push(lounge)
    
    lounge = Lounge.new(3, "Delta Premium Lounge", airport, description="We're Delta...")
    @lounge_list.push(lounge)
  end

  def fetch_many()
    return @lounge_list
  end
  
  def fetch_by_id(id)
    return @lounge_list[id.to_i - 1]
  end
end
