require 'application_errors'
require 'repositories/sessions/sessions_repository'

class ApplicationController < ActionController::Base
  before_action :check_for_session
  rescue_from NotFoundError, :with => :render_404

  protected
 
  def render_400(error_description)
    render :json => { :error => '400 - Bad Request', :error_description => error_description }, :status => 400
  end
  
  def render_403
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end

  def render_404(e)
    logger.warn("Rendering 404 error! -> " + e.to_s())
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  private

  def check_for_session
    session_id = cookies.encrypted[:session_id]
    redirect_to_new_session and return if session_id.nil?
   
    begin
      @session = create_sessions_repository.fetch_by_id(session_id)
    rescue NotFoundError => e
      redirect_to_new_session
    end
  end

  def redirect_to_new_session
      redirect_to :controller => 'sessions', :action => 'new'
  end
end
