class CommentsController < ApplicationController
  COMMENT_FAN_RANKING_POINTS = 20

  def create
    if current_user == nil
      send_401
      return
    end
    @commentable_type = params[:comment][:commentable_type]
    @commentable_id = params[:comment][:commentable_id]
    # Finds the commentable
    if @commentable_type == "Post"
      @commentable = Post.find(@commentable_id)
    elsif @commentable_type == "Track"
      @commentable = Track.find(@commentable_id)
    else
      raise "parameter '#{@commentable_type}' for commentable_type is not valid!"
    end
    follow = get_follow(@commentable.owner)
    # Creates the Comment
    @comment = Comment.new(comment_params)
    @comment.owner = current_user
    @comment.commentable = @commentable
    respond_to do |format|
      if !@comment.save
        flash[:error] = "An Error has occured"
      end
      if follow
        follow.fan_ranking_points += COMMENT_FAN_RANKING_POINTS
        follow.save
      end
      # Adds Fan Ranking points
      format.js
    end
  end

  def delete
    # Defensive Checks
    if @comment == nil
      send_404
      return
    end
    if current_user != @comment.owner
      send_401
      return
    end

    @comment = Comment.find(params[:comment_id])
    @comment.removed = true
    @comment.save
    respond_to do |format|
      @commentable = @comment.commentable
      follow = get_follow(@commentable.owner)
      if follow
        follow.fan_ranking_points -= COMMENT_FAN_RANKING_POINTS
        follow.save
      end
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
