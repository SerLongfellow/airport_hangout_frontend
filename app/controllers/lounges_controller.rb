
require 'repositories/lounges/lounges_repository'
require 'repositories/users/users_repository'


class LoungesController < ApplicationController
  def initialize(lounges_repo_class=MemoryLoungesRepository,
                 users_repo_class=MemoryUsersRepository)
    super()
    @lounges_repo = lounges_repo_class.new
    @users_repo = users_repo_class.new
  end

  def index()
    @lounges = @lounges_repo.fetch_many(params[:airport_id])
  end

  def show()
    @lounge = @lounges_repo.fetch_by_id(params[:airport_id], params[:id])
    @user = @users_repo.fetch_user(session[:current_user_id])
  end
end
