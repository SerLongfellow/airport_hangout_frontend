
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
    user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user

    @conversation = @conversations_repo.fetch_by_id(params[:id])
    remote_party_id = @conversation.recipient_id

    if remote_party_id == user.id
      remote_party_id = @conversation.sender_id
    end
      
    @remote_party = @patrons_repo.fetch_by_id(remote_party_id)
    @current_user = user

    puts "Remote party: " + @remote_party.inspect
  end

  def create
    patron_id = params[:patron_id]

    patron = @patrons_repo.fetch_by_id(patron_id)
    user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user

    begin
      conversation = @conversations_repo.fetch_by_participant_ids(user.id, patron.id)
    rescue NotFoundError => e
      conversation = nil
    end
    
    if conversation.nil?
      # create new conversation by redirecting to show
      conversation = Conversation.new(user.id, patron.id)
      conversation = @conversations_repo.create!(conversation)
    else
      puts "Found conversation #{conversation.id}, no need to create new one"
    end
      
    redirect_to conversation_path(conversation.id)
  end
end
