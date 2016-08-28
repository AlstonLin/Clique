class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    # Defensive Check
    unless @conversation.users.include?(current_user)
      send_401
      return
    end
    respond_to do |format|
      format.js
    end
  end
end
