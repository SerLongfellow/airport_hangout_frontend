class PatronsController < ApplicationController
 
  def initialize
    super
    @patrons_repo = create_patrons_repository
  end
  
  def index()
    @patrons = @patrons_repo.fetch_many(params[:lounge_id], @session.current_user.id)
    render :partial => 'patrons/index'
  end
  
  def create()
    current_user = @session.current_user
    lounge = create_lounges_repository.fetch_by_id(params[:lounge_id])

    @patrons_repo.leave_lounge(current_user.current_lounge.id, current_user) unless current_user.current_lounge.nil?
    @patrons_repo.check_into_lounge(lounge.id, current_user)
    create_users_repository.check_into_lounge(lounge, current_user)
    
    redirect_to lounge_path(lounge.id)
  end

  def destroy()
    current_user = @session.current_user
    lounge = create_lounges_repository.fetch_by_id(params[:lounge_id])

    @patrons_repo.leave_lounge(lounge.id, current_user)
    create_users_repository.check_into_lounge(nil, current_user)

    redirect_to lounge_path(lounge.id)
  end
end
