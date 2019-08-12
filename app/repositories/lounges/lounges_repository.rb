
require 'repositories/application_repository'
require 'repositories/airports/airports_repository'


class LoungesRepository < ApplicationRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end
  
  def fetch_by_id(id)
    raise NoMethodError.new(not_implemented_error)
  end
  
  def update_patron_count(id, inc)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryLoungesRepository < LoungesRepository

  @@initialized = false
  
  def initialize()
    return if @@initialized

    airports_repo = MemoryAirportsRepository.new

    @@airports = {}

    airport = airports_repo.fetch_by_id(1)
    
    lounge_list = []
    lounge = Lounge.new("1", "Cool-Ass Playas Lounge", airport, description="Where all the cool kids come to play...", number_of_patrons=2)
    lounge_list.push(lounge)

    lounge = Lounge.new("2", "I Want My IPA Lounge", airport, description="Over 9,000 IBU's!")
    lounge_list.push(lounge)
    
    lounge = Lounge.new("3", "Delta Premium Lounge", airport, description="We're Delta...")
    lounge_list.push(lounge)

    @@airports["1"] = lounge_list

    airport = airports_repo.fetch_by_id(2)
    
    lounge_list = []
    lounge = Lounge.new("4", "Whole Hog Barbeque", airport, description="Getcha some grub!")
    lounge_list.push(lounge)
    
    @@airports["2"] = lounge_list

    @@initialized = true
  end

  def fetch_many(airport_id)
    puts @@airports
    return @@airports[airport_id]
  end
  
  def fetch_by_id(airport_id, lounge_id)
    airport = @@airports[airport_id]
    puts airport
    if airport.nil?
      return nil
    else
      return airport.find { |lounge| lounge.id == lounge_id }
    end
  end
  
  def update_patron_count(airport_id, lounge_id, inc)
    lounge = fetch_by_id(airport_id, lounge_id)

    if lounge.nil?
      return false
    end

    lounge.number_of_patrons += inc
    return true
  end
end
