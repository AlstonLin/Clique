class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
