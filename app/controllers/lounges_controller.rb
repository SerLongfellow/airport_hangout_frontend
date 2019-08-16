
require 'repositories/lounges/lounges_repository'
require 'repositories/sessions/sessions_repository'


class LoungesController < ApplicationController
  def initialize(lounges_repo_class=MemoryLoungesRepository)
    super()
    @lounges_repo = lounges_repo_class.new
  end

  def index()
    @lounges = @lounges_repo.fetch_many(params[:airport_id])
  end

  def show()
    @lounge = @lounges_repo.fetch_by_id(params[:id])
    @user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
  end
end
