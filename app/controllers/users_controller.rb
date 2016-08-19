class UsersController < ApplicationController
  MAX_FAVOURITE_ARTISTS = 5
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @users = User.all
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = "Successfully Updated"
      redirect_to current_user
    else
      flash[:alert] = "There was a problem while updating"
      redirect_to current_user
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    @content = get_all_content
    @partial = "all"
    set_profile_variables(@user)
    @show_right = true
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def message
    @user = User.find_by_username(params[:user_id])
    @message = Message.new
    respond_to do |format|
      format.js
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  def follow
    @user = User.find_by_username(params[:user_id])
    raise "Attempt to follow self" unless current_user != @user
    follows = Follow.where(:follower => current_user).where(:following => @user)
    if follows.count > 0
      follow = follows[0]
      if follow.active #Unfollow
        follow.active = false
      else # Refollow
        follow.active = true
      end
      follow.save
    else # New Follow
      Follow.create :follower => current_user, :following => @user
    end
    # Response
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end
  # ------------------------- Profile Tabs -------------------------------------
  def all
    @partial = "all"
    @user = User.find_by_username(params[:user_id])
    @content = get_all_content
    @show_right = true
    set_profile_variables(@user)
    render :action => :show
  end

  def posts
    @user = User.find_by_username(params[:user_id])
    @posts = @user.get_posts(false)
    @partial = "posts"
    @show_right = true
    set_profile_variables(@user)
    render :action => :show
  end

  def clique
    @user = User.find_by_username(params[:user_id])
    @content = @user.get_tracks(true) + @user.get_posts(true)
    @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    @partial = "clique"
    @show_right = true
    set_profile_variables(@user)
    render :action => :show
  end

  def tracks
    @user = User.find_by_username(params[:user_id])
    @tracks = @user.get_tracks(false)
    @partial = "tracks"
    @show_right = true
    set_profile_variables(@user)
    render :action => :show
  end

  def followers
    @user = User.find_by_username(params[:user_id])
    @followers = @user.followers
    @partial = "followers"
    @show_right = false
    set_profile_variables(@user)
    render :action => :show
  end

  def following
    @user = User.find_by_username(params[:user_id])
    @following = @user.following
    @partial = "following"
    @show_right = false
    set_profile_variables(@user)
    render :action => :show
  end
  #---------------------EXTERNALIZED FUNCTIONS----------------------------------
  private
    def get_all_content
      # Show all content
      if (@user == current_user) || (@user.clique && current_user && @user.clique.is_subscribed?(self))
        @content = @user.get_tracks(nil) + @user.get_posts(nil)
      # Show all non-clique content
      else
        @content = @user.get_tracks(false) + @user.get_posts(false)
      end
      # Sort
      @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    end

    # Sets up variables that show on all profile tabs
    def set_profile_variables(user)
      @top_fans = user.followers.order(:fan_ranking_points => :desc).limit(MAX_FAVOURITE_ARTISTS)
      @top_follows = user.following.order(:fan_ranking_points => :desc).limit(MAX_FAVOURITE_ARTISTS)
    end

  	def user_params
  			params.require(:user).permit(:bio, :first_name, :last_name, :username,
        :profile_picture, :cover_picture, :password, :password_confirmation)
  	end
end
