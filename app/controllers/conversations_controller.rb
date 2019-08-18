
class ConversationsController < ApplicationController
  def index
    @current_user = @session.current_user
    @conversations = create_conversations_repository.fetch_many(@session.current_user.id)
  end

  def show
    @current_user = @session.current_user
    @conversation = create_conversations_repository.fetch_by_id(params[:id])
    remote_party_id = @conversation.recipient_id

    if remote_party_id == @current_user
      remote_party_id = @conversation.sender_id
    end
      
    @remote_party = create_users_repository.fetch_user(remote_party_id)
  end

  def create
    patron_id = params[:patron_id]

    begin
      patron = create_users_repository.fetch_user(patron_id)
    rescue NotFoundError => e
      render_400("No patron found with ID #{patron_id}")
      return
    end

    conversations_repo = create_conversations_repository

    begin
      conversation = conversations_repo.fetch_by_participant_ids(@session.current_user.id, patron.id)
    rescue NotFoundError => e
      conversation = nil
    end
    
    if conversation.nil?
      # create new conversation by redirecting to show
      conversation = Conversation.new(@session.current_user.id, patron.id)
      conversation = conversations_repo.create!(conversation)
    else
      puts "Found conversation #{conversation.id}, no need to create new one"
    end
      
    redirect_to conversation_path(conversation.id)
  end
end
