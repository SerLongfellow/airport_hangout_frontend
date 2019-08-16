require 'repositories/sessions/sessions_repository'

class HomeController < ApplicationController
  def initialize(sessions_repo_class=MemorySessionsRepository)
    @sesssions_repo = sessions_repo_class.new
  end

  def index()
    @user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
  end
end
