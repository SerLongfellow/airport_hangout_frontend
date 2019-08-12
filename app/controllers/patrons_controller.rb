
require 'repositories/patrons/patrons_repository'
require 'repositories/users/users_repository'
require 'repositories/lounges/lounges_repository'


class PatronsController < ApplicationController
 
  def initialize(patrons_repo_class=MemoryPatronsRepository, 
                 users_repo_class=MemoryUsersRepository,
                 lounges_repo_class=MemoryLoungesRepository)
    @patrons_repo = patrons_repo_class.new
    @users_repo = users_repo_class.new
    @lounges_repo = lounges_repo_class.new
  end
  
  def index()
    @patrons = @patrons_repo.fetch_many(params[:lounge_id], session[:current_user_id])
  end
  
  def create()
    lounge = @lounges_repo.fetch_by_id(params[:airport_id], params[:lounge_id])
    user = @users_repo.fetch_user(session[:current_user_id])

    unless user.current_lounge.nil?
      @patrons_repo.leave_lounge(user.current_lounge.airport.id, user.current_lounge.id, user)
    end

    user = @users_repo.check_into_lounge(lounge, user)
    @patrons_repo.check_into_lounge(lounge.airport.id, lounge.id, user)

    redirect_to airport_lounge_path(lounge.airport.id, lounge.id)
  end

  def destroy()
    lounge = @lounges_repo.fetch_by_id(params[:airport_id], params[:lounge_id])
    user = @users_repo.fetch_user(session[:current_user_id])
   
    @patrons_repo.leave_lounge(lounge.airport.id, lounge.id, user)
    @users_repo.check_into_lounge(nil, user)

    redirect_to airport_lounge_path(lounge.airport.id, lounge.id)
  end
end
