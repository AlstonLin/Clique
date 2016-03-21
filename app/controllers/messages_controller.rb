class MessagesController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @conversations = get_conversations
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
  def conversation
    @other = User.find(params[:message_id])
    @messages = get_messages @other
    respond_to do |format|
      format.js
    end
  end

  def create
    @to = User.find_by_username params[:username]
    raise "Cannot message self" unless @to != current_user
    if @to
      # Valid username; builds message
      @message = Message.new(message_params)
      @message.to = @to
      @message.from = current_user
      # Response
      respond_to do |format|
        if @message.save
          flash[:notice] = "Message Sent!"
          @messages = get_messages @to
          @other = @to
        else
          flash[:alerrt] = "There was an error while sending the message"
        end
        format.js
      end
    else
      # Not a valid username
      flash[:alert] = "User not found!"
    end
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end

  private
  def get_conversations
    # Variables
    conversations = []
    users = Message.where("to_id = #{current_user.id} OR from_id = #{current_user.id}").order('created_at DESC').map{ |m| [m.from, m.to]}.uniq
    # Filters out the current user from the list
    users.each do |u|
      if u[0] != current_user
        conversations << u[0]
      else
        conversations << u[1]
      end
    end
    return conversations.uniq
  end

  private
  def get_messages(other)
    messages = Message.where(:from => current_user, :to => other) + Message.where(:from => other, :to => current_user)
    return messages.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
  end
end
