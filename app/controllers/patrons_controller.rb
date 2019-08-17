
require 'repositories/patrons/patrons_repository'
require 'repositories/users/users_repository'
require 'repositories/lounges/lounges_repository'


class PatronsController < ApplicationController
 
  def initialize(patrons_repo_class=MemoryPatronsRepository, 
                 users_repo_class=MemoryUsersRepository,
                 lounges_repo_class=MemoryLoungesRepository)
    super()
    @patrons_repo = patrons_repo_class.new
    @users_repo = users_repo_class.new
    @lounges_repo = lounges_repo_class.new
  end
  
  def index()
    @user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
    @patrons = @patrons_repo.fetch_many(params[:lounge_id], @user.id)

    render :partial => 'patrons/index'
  end
  
  def create()
    @user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
    lounge = @lounges_repo.fetch_by_id(params[:lounge_id])

    @patrons_repo.leave_lounge(@user.current_lounge.id, @user) unless @user.current_lounge.nil?
    @patrons_repo.check_into_lounge(lounge.id, @user)
    
    @user = @users_repo.check_into_lounge(lounge, @user)

    redirect_to lounge_path(lounge.id)
  end

  def destroy()
    @user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
    lounge = @lounges_repo.fetch_by_id(params[:lounge_id])

    @patrons_repo.leave_lounge(lounge.id, @user)
    @users_repo.check_into_lounge(nil, @user)

    redirect_to lounge_path(lounge.id)
  end
end
