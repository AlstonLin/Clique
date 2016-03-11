class TrackCommentsController < ApplicationController
  def create
    @comment = TrackComment.new(comment_params)
    @comment.creator = current_user
    respond_to do |format|
      if !@comment.save
        flash[:error] = "An Error has occured"
      end
      @track = @comment.track
      format.js
    end
  end

  private
  def comment_params
    params.require(:track_comment).permit(:content, :track_id)
  end
end