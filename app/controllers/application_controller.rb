
require 'repositories/sessions/sessions_repository'

class ApplicationController < ActionController::Base
  before_action :check_for_session

  private

  def check_for_session()
    if session[:current_user_id].nil?
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end
end
