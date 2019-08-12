class SessionsController < ApplicationController
  skip_before_action :check_for_session, only: [:new, :create]

  def new()
  end

  def create()
    session[:current_user_id] = params[:user_id]
    redirect_to :controller => 'home', :action => 'index'
  end
end
