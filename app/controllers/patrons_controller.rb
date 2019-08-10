
require 'repositories/patrons/patrons_repository'

class PatronsController < ApplicationController
 
  def initialize(repository_class=MemoryPatronsRepository)
    @repository = repository_class.new
  end
  
  def index()
    @patrons = @repository.fetch_many(params[:lounge_id])
  end
end
