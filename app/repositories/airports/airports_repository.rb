class AirportsRepository < ApplicationRepository
  def fetch_many
    raise NoMethodError.new(not_implemented_error)
  end
  
  def fetch_by_id
    raise NoMethodError.new(not_implemented_error)
  end

  def create(airport)
    raise NoMethodError.new(not_implemented_error)
  end
end

class MemoryAirportsRepository < AirportsRepository

  @@initialized = false
  
  def initialize
    return if @@initialized
    reset

    if ENV['RAILS_ENV'] == 'development'
      airport = Airport.new('1', 'SEA', 'Seatac, WA - Seattle-Tacoma International Airport')
      @@airports.push(airport)

      airport = Airport.new('2', 'LIT', 'Little Rock, AR - Clinton National Airport')
      @@airports.push(airport)
    end

    @@initialized = true
  end

  def fetch_many
    return @@airports
  end
  
  def fetch_by_id(id)
    return @@airports[id.to_i - 1]
  end
  
  def create(airport)
    @@airports.push(airport)
  end

  def reset
    @@airports = []
  end
end

class MemoryAirportsRepositoryFactory
  def self.create_repository
    MemoryAirportsRepository.instance
  end
end

class AirportsRepositoryFactory < ApplicationRepositoryFactory
  def self.repo_type
    :airports
  end
end
