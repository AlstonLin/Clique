class PostsController < ApplicationController
  REPOST_FAN_RANKING_POINTS = 30
  LIKE_FAN_RANKING_POINTS = 10

  # ----------------------- Default RESTFUL Actions-----------------------------
  def create
    if current_user == nil
      send_401
      return
    end

    @post = Post.new(post_params)

    if @post == nil
      send_404
      return
    end

    @post.owner = current_user
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
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def update
    @post = Post.find(params[:post_id])

    if @post == nil
      send_404
      return
    end

    if current_user != @post.owner
      send_401
      return
    end

    respond_to do |format|
      if @post.update(post_params)
        flash[:notice] = "Post Updated!"
      else
        flash[:error] = "An Error has occured"
      end
      @posts = current_user.get_posts(false) + current_user.get_posts(nil)
      @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
      # JS Reponse
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def delete
    @post = Post.find(params[:post_id])

    if @post == nil
      send_404
      return
    end

    if current_user != @post.owner
      send_401
      return
    end

    @post.removed = true
    respond_to do |format|
      if @post.save
        flash[:notice] = "Post Deleted!"
      else
        flash[:error] = "An Error has occured"
      end
      # Show all content for response
      @content = current_user.get_tracks(nil) + current_user.get_posts(nil)
      @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
      # JS Reponse
      format.js { render 'shared/reload.js.erb' }
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def repost
    @post = Post.find(params[:post_id])

    if @post == nil
      send_404
      return
    end

    if current_user == nil
      send_401
      return
    end

    @repost = Repost.where(:post => @post).where(:reposter => current_user)
    follow = get_follow(@post.owner)
    if @repost.count > 0
      @repost.first.destroy
      flash[:notice] = "Repost deleted"
      # Removes Fan Ranking points
      if follow
        follow.fan_ranking_points -= REPOST_FAN_RANKING_POINTS
        follow.save
      end
    else
      if Repost.create :post => @post, :reposter => current_user
        flash[:notice] = "Reposted!"
        # Adds Fan Ranking points
        if follow
          follow.fan_ranking_points += REPOST_FAN_RANKING_POINTS
          follow.save
        end
      else
        flash[:error] = "An Error has occured"
      end
    end
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def favorite
    @post = Post.find(params[:post_id])

    if @post == nil
      send_404
      return
    end

    if current_user == nil
      send_401
      return
    end

    favourite = Favourite.where(:favouritable => @post, :favouriter => current_user)
    follow = get_follow(@post.owner)
    if favourite.count > 0
      if favourite[0].destroy
        flash[:notice] = "Unfavorited!"
        # Removes Fan Ranking points
        if follow
          follow.fan_ranking_points -= LIKE_FAN_RANKING_POINTS
          follow.save
        end
      else
        flash[:error] = "An error has occured"
      end
    else
      if Favourite.create :favouritable => @post, :favouriter => current_user
        flash[:notice] = "Favorited!"
        # Adds Fan Ranking points
        if follow
          follow.fan_ranking_points += LIKE_FAN_RANKING_POINTS
          follow.save
        end
      else
        flash[:error] = "An error has occured"
      end
    end
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def load_modal
    @post = Post.find(params[:post_id])

    if @post == nil
      send_404
      return
    end

    respond_to do |format|
      format.js
    end
  end
  # --------------------------------- Other-------------------------------------
  private
  def post_params
    params.require(:post).permit(:content, :clique_only)
  end
end
