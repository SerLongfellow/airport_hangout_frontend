require 'repositories/sessions/sessions_repository'

class HomeController < ApplicationController
  def index()
    @current_user = @session.current_user
  end
end
