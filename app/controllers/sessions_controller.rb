require 'securerandom'
require 'repositories/users/users_repository'
require 'repositories/sessions/sessions_repository'

class SessionsController < ApplicationController
  skip_before_action :check_for_session, only: [:new, :create]

  def initialize(users_repo_class=MemoryUsersRepository)
    super()
    @users_repo = users_repo_class.new
  end

  def new()
  end

  def create()
    user = User.new("-1", params[:name], params[:hometown])
    user = @users_repo.create_user(user)
    
    session = Session.new(SecureRandom.uuid, user)
    @sessions_repo.create(session)
    cookies.encrypted[:session_id] = session.id
    
    redirect_to :controller => 'home', :action => 'index'
  end
end
