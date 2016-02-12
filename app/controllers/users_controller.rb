class UsersController < ApplicationController
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
    @posts = @user.get_posts(false)
    # Create Post
    if @user == current_user
      @post = Post.new
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
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
    # TODO: Some validation for if already following
    # Creates new Follow
    follow = Follow.new
    follow.follower = current_user
    follow.following = @user
    # Response
    respond_to do |format|
      if follow.save
        flash[:notice] = "Followed " + @user.name
      else
        flash[:error] = "An error has occured"
      end
      format.js
    end
  end

  def unfollow
    # TODO: Some validation for if not following
    # Finds the follow
    @user= User.find_by_username(params[:user_id])
    follows = Follow.where(:follower => current_user, :following => @user)
    follows.destroy_all
    # Response
    respond_to do |format|
      flash[:notice] = "Unfollowed " + @user.name
      format.js
    end
  end

  def posts
    @user = User.find_by_username(params[:user_id])
    @posts = @user.get_posts(false)
    respond_to do |format|
      format.js
    end
  end

  def reposts
    @user = User.find_by_username(params[:user_id])
    @reposts = @user.reposts
    respond_to do |format|
      format.js
    end
  end

  def clique
    @user = User.find_by_username(params[:user_id])
    @content = @user.get_tracks(true) + @user.get_posts(true)
    @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    respond_to do |format|
      format.js
    end
  end

  def songs
    @user = User.find_by_username(params[:user_id])
    @songs = @user.get_tracks(false)
    respond_to do |format|
      format.js
    end
  end

  def followers
    @user = User.find_by_username(params[:user_id])
    @followers = @user.followers
    respond_to do |format|
      format.js
    end
  end

  def following
    @user = User.find_by_username(params[:user_id])
    @following = @user.following
    respond_to do |format|
      format.js
    end
  end
  #---------------------EXTERNALIZED FUNCTIONS----------------------------------
  private
	def user_params
			params.require(:user).permit(:bio, :first_name, :last_name, :username,
      :profile_picture, :cover_picture, :password, :password_confirmation)
	end
end
