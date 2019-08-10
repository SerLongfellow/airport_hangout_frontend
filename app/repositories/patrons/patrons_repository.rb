
class PatronsRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end

  private

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end

class MemoryPatronsRepository < PatronsRepository
  
  def initialize()
    @lounge_patrons = []

    #lounge = Lounge.new(1, "Cool-Ass Playas Lounge", airport, description="Where all the cool kids come to play...")
    patrons_list = []
    patrons_list.push(Patron.new(1, "Billy Bob", "Little Rock, AR"))
    patrons_list.push(Patron.new(2, "Foo Bar", "Seattle, WA"))
    @lounge_patrons.push(patrons_list)

    #lounge = Lounge.new(2, "I Want My IPA Lounge", airport, description="Over 9,000 IBU's!")
    patrons_list = []
    @lounge_patrons.push(patrons_list)
    
    #lounge = Lounge.new(3, "Delta Premium Lounge", airport, description="We're Delta...")
    patrons_list = []
    @lounge_patrons.push(patrons_list)
  end

  def fetch_many(lounge_id)
    return @lounge_patrons[lounge_id.to_i - 1]
  end
end
