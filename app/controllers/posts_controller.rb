class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.poster = current_user
    @post.posted_time = Time.now
    respond_to do |format|
      if @post.save
        flash[:notice] = "Post Created!"
      else
        flash[:error] = "An Error has occured"
      end
      @post = Post.new
      @posts = Post.all
      format.js
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        flash[:notice] = "Post Updated!"
      else
        flash[:error] = "An Error has occured"
      end
      @posts = Post.all
      format.js
    end
  end

  private
  def post_params
    params.require(:post).permit(:content, :clique_only)
  end
end
