class AirportsController < ApplicationController
  def index
    @airports = AirportsRepositoryFactory.create_repository.fetch_many()
    @selected_airport = @airports.first
  end
end
