
require 'repositories/conversations/conversations_repository'
require 'repositories/patrons/patrons_repository'


class ConversationsController < ApplicationController
  def initialize(conversations_repo_class=MemoryConversationsRepository,
                 users_repo_class=MemoryUsersRepository)
    super()
    @conversations_repo = conversations_repo_class.new()
    @users_repo = users_repo_class.new()
  end

  def index
    @current_user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user
    @conversations = @conversations_repo.fetch_many(@current_user.id)
  end

  def show
    user = @sessions_repo.fetch_by_id(cookies.encrypted[:session_id]).current_user

    @conversation = @conversations_repo.fetch_by_id(params[:id])
    remote_party_id = @conversation.recipient_id

    if remote_party_id == user.id
      remote_party_id = @conversation.sender_id
    end
      
    @remote_party = @users_repo.fetch_user(remote_party_id)
    @current_user = user
  end

  def create
    patron_id = params[:patron_id]

    patron = @users_repo.fetch_user(patron_id)
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
