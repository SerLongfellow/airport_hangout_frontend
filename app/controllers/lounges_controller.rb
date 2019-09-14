
class LoungesController < ApplicationController
  def index()
    @lounges = LoungesRepositoryFactory.create_repository.fetch_many(params[:airport_id])
  end

  def show()
    @lounge = LoungesRepositoryFactory.create_repository.fetch_by_id(params[:id])
    @current_user = @session.current_user
  end
end
