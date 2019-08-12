
require 'repositories/users/users_repository'
require 'repositories/airports/airports_repository'


class HomeController < ApplicationController
  def index()
    users_repository = MemoryUsersRepository.new
    @user = users_repository.fetch_user(session[:current_user_id])
  end
end
