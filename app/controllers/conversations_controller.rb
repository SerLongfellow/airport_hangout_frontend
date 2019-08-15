
require 'repositories/conversations/conversations_repository'
require 'repositories/patrons/patrons_repository'


class ConversationsController < ApplicationController
  def initialize(conversations_repo_class=MemoryConversationsRepository,
                 patrons_repo_class=MemoryPatronsRepository)
    super()
    @conversations_repo = conversations_repo_class.new()
    @patrons_repo = patrons_repo_class.new()
  end

  def show
    patron_id = params[:id]

    @patron = @patrons_repo.fetch_by_id(patron_id)
    @messages = @conversations_repo.fetch_many(session[:current_user_id], patron_id)
  end
end
