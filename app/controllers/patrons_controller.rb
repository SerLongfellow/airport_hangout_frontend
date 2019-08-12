
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
    lounge = @lounges_repo.fetch_by_id(params[:lounge_id])
    user = @users_repo.fetch_user(session[:current_user_id])

    unless user.current_lounge.nil?
      @patrons_repo.leave_lounge(user.checked_into_lounge.id, user.id)
    end

    user = @users_repo.check_into_lounge(lounge, user)
    @patrons_repo.check_into_lounge(lounge.id, user.id)
  end
end
