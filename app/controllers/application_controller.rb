
require 'repositories/application_repository'
require 'repositories/sessions/sessions_repository'


class ApplicationController < ActionController::Base
  before_action :check_for_session
  rescue_from RepositoryErrors::NotFoundError, :with => :render_404

  protected
  def render_403()
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end

  def render_404(e)
    #puts e
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  private
  def check_for_session()
    if session[:current_user_id].nil?
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end
  
end
