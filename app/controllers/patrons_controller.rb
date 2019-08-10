
require 'repositories/patrons/patrons_repository'

class PatronsController < ApplicationController
 
  def initialize(repository_class=MemoryPatronsRepository)
    @repository = repository_class.new
  end
  
  def index()
    @patrons = @repository.fetch_many(params[:lounge_id])
  end
  
  def create()
    @repository.check_into_lounge(params[:lounge_id], 7) # want to get session user Id here...
  end
end
