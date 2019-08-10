
class PatronsRepository
  def fetch_many(lounge_id)
    raise NoMethodError.new(not_implemented_error)
  end

  def check_into_lounge(lounge_id, patron_id)
    raise NoMethodError.new(not_implemented_error)
  end

  private

  def not_implemented_error()
    caller_method = caller_locations.first.label
    return "'#{caller_method}' method must be implemented"
  end
end

class MemoryPatronsRepository < PatronsRepository

  @@initialized = false
  
  def initialize()
    if @@initialized
      return
    end

    puts "Creating new patrons repo"
    @@lounge_patrons = []

    #lounge = Lounge.new(1, "Cool-Ass Playas Lounge", airport, description="Where all the cool kids come to play...")
    patrons_list = []
    patrons_list.push(Patron.new(1, "Billy Bob", "Little Rock, AR"))
    patrons_list.push(Patron.new(2, "Foo Bar", "Seattle, WA"))
    @@lounge_patrons.push(patrons_list)

    #lounge = Lounge.new(2, "I Want My IPA Lounge", airport, description="Over 9,000 IBU's!")
    patrons_list = []
    @@lounge_patrons.push(patrons_list)
    
    #lounge = Lounge.new(3, "Delta Premium Lounge", airport, description="We're Delta...")
    patrons_list = []
    @@lounge_patrons.push(patrons_list)

    @@initialized = true
  end

  def fetch_many(lounge_id)
    lounge = @@lounge_patrons[lounge_id.to_i - 1]
    return lounge
  end
  
  def check_into_lounge(lounge_id, patron_id)
    lounge = fetch_many(lounge_id)

    if !lounge.nil?
      lounge.push(Patron.new(patron_id, "New Patron", "Tacoma, WA"))
      return true
    else
      return false
    end
  end
end
