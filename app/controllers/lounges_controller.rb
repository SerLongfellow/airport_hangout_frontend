
require 'repositories/lounges/lounges_repository'


class LoungesController < ApplicationController
  def index()
    repository = LoungesRepository.new
    repository.fetch()
  end

  def show()
  end
end
