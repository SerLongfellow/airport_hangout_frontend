
require 'repositories/airports/airports_repository'


class AirportsController < ApplicationController
  def initialize(airports_repo_class=MemoryAirportsRepository)
    super()
    @airports_repo = airports_repo_class.new
  end

  def index()
    @airports = @airports_repo.fetch_many()
    @selected_airport = @airports.first
  end
end
