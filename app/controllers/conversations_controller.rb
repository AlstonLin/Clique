class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    # Defensive Check
    unless current_user in @conversation.users
      send_401
      return
    end
    respond_to do |format|
      format.js
    end
  end
end
