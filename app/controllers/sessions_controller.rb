require 'securerandom'

require 'users/users_repository'

class SessionsController < ApplicationController
  skip_before_action :check_for_session, only: [:new, :create]

  def new()
    # Nothing to do here
  end

  def create()
    user = User.new("-1", params[:name], params[:hometown])
    user = UsersRepositoryFactory.create_repository.create_user(user)
    
    session = Session.new(SecureRandom.uuid, user)
    SessionsRepositoryFactory.create_repository.create(session)
    cookies.encrypted[:session_id] = session.id
    
    redirect_to :controller => 'home', :action => 'index'
  end
end
