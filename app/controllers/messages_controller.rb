class MessagesController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    if current_user == nil
      send_401
      return
    end

    @conversations = current_user.conversations
    respond_to do |format|
      format.js
    end
  end

  def new
    @message = Message.new
    respond_to do |format|
      format.js
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def create
    if current_user == nil
      send_401
      return
    end

    if params.has_key? :username
      to = User.find_by_username params[:username]
      @conversation = get_conversation to
    else
      @conversation = Conversation.find params[:conversation_id]
    end
    # Builds Message
    message = Message.new(message_params)
    message.creator = current_user
    message.conversation = @conversation
    # Response
    respond_to do |format|
      if !message.save
        flash[:alert] = "There was an error while sending the message"
      end
      format.js
    end
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end

  private
  def get_conversation(to)
    raise "User not found" unless to
    raise "Cannot message self" unless to != current_user
    conversation = current_user.conversations.select{ |c| c.users.count == 2 && c.users.include?(to) }
    if conversation.count == 0
      # Creates new conversation
      conversation = Conversation.new
      conversation.users << current_user
      conversation.users << to
      conversation.save
    else
      # Continue existing conversation
      conversation = conversation[0]
    end
    return conversation
  end
end
