
require 'repositories/users/users_repository'


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
    
    session[:current_user_id] = user.id
    
    redirect_to :controller => 'home', :action => 'index'
  end
end
