
require 'repositories/application_repository'


class AirportsRepository < ApplicationRepository
  def fetch_many()
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryAirportsRepository < AirportsRepository

  @@initialized = false
  
  def initialize()
    return if @@initialized

    @@airports = []

    airport = Airport.new("1", "SEA", "Seatac, WA - Seattle-Tacoma International Airport")
    @@airports.push(airport)
    
    airport = Airport.new("2", "LIT", "Little Rock, AR - Clinton National Airport")
    @@airports.push(airport)

    @@initialized = true
  end

  def fetch_many()
    return @@airports
  end
  
  def fetch_by_id(id)
    return @@airports[id.to_i - 1]
  end
end
