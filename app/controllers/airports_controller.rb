class AirportsController < ApplicationController
  def index()
    @airports = create_airports_repository.fetch_many()
    @selected_airport = @airports.first
  end
end
