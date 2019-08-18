class LoungesController < ApplicationController
  def index()
    @lounges = create_lounges_repository.fetch_many(params[:airport_id])
  end

  def show()
    @lounge = create_lounges_repository.fetch_by_id(params[:id])
    @current_user = @session.current_user
  end
end
