class PostCommentsController < ApplicationController
  def create
    @comment = PostComment.new(comment_params)
    @comment.creator = current_user
    respond_to do |format|
      if !@comment.save
        flash[:error] = "An Error has occured"
      end
      @post = @comment.post
      format.js
    end
  end

  private
  def comment_params
    params.require(:post_comment).permit(:content, :post_id)
  end
end
