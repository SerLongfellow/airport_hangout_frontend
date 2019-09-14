
class HomeController < ApplicationController
  def index()
    @current_user = @session.current_user
  end
end
