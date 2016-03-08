class PostsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def create
    @post = Post.new(post_params)
    @post.poster = current_user
    respond_to do |format|
      if @post.save
        flash[:notice] = "Post Created!"
      else
        flash[:error] = "An Error has occured"
      end
      # Show all content for response
      @content = current_user.get_tracks(nil) + current_user.get_posts(nil)
      @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
      @user = current_user
      @post = Post.new
      # JS Reponse
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
      @posts = current_user.get_posts(false) + current_user.get_posts(nil)
      @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
      # JS Reponse
      format.js
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def repost
    @post = Post.find(params[:post_id])
    @post.reposters << current_user
    respond_to do |format|
      if @post.save
        flash[:notice] = "Reposted!"
      else
        flash[:error] = "An Error has occured"
      end
      format.js
    end
  end

  def favorite
    @post = Post.find(params[:post_id])
    if @post.favoriters.include? current_user
      @post.favoriters.delete(current_user)
    else
      @post.favoriters << current_user
    end
    @favorites = current_user.get_favorites
    respond_to do |format|
      if @post.save
        flash[:notice] = "Favorited!"
      else
        flash[:error] = "An Error has occured"
      end
      format.js
    end
  end
  # --------------------------------- Other-------------------------------------
  private
  def post_params
    params.require(:post).permit(:content, :clique_only)
  end
end
