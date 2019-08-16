require 'application_errors'
require 'repositories/sessions/sessions_repository'

class ApplicationController < ActionController::Base
  before_action :check_for_session
  rescue_from NotFoundError, :with => :render_404

  def initialize
    super
    sessions_repo
  end

  protected

  def sessions_repo
    @sessions_repo = MemorySessionsRepository.new
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
    begin
      redirect_to_new_session if session_id.nil? || sessions_repo.fetch_by_id(session_id).nil?
    rescue NotFoundError => e
      redirect_to_new_session
    end
  end

  def redirect_to_new_session
      redirect_to :controller => 'sessions', :action => 'new'
  end
end
