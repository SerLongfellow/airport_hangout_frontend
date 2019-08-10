
require 'repositories/lounges/lounges_repository'


class LoungesController < ApplicationController
  def initialize(repository_class=MemoryLoungesRepository)
    super()
    @repository = repository_class.new
  end

  def index()
    @lounges = @repository.fetch_many()
  end

  def show()
    @lounge = @repository.fetch_by_id(params[:id])

    if @lounge.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end
end
