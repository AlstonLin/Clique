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
    @posts = filter_clique_only(@user.posts, false)
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
    @followed = User.find_by_username(params[:user_id])
    raise "Attempt to follow self" unless current_user != @followed
    # TODO: Some validation for if already following
    # Creates new Follow
    follow = Follow.new
    follow.follower = current_user
    follow.following = @followed
    # Response
    respond_to do |format|
      if follow.save
        flash[:notice] = "Followed " + @followed.name
      else
        flash[:error] = "An error has occured"
      end
      format.js
    end
  end

  def posts
    @user = User.find_by_username(params[:user_id])
    @posts = filter_clique_only(@user.posts, false)
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
    @songs = filter_clique_only(@user.tracks, true)
    @posts = filter_clique_only(@user.posts, true)

    respond_to do |format|
      format.js
    end
  end

  def songs
    @user = User.find_by_username(params[:user_id])
    @songs = filter_clique_only(@user.tracks, false)
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
	def user_params
			params.require(:user).permit(:bio, :first_name, :last_name, :username,
      :profile_picture, :cover_picture, :password, :password_confirmation)
	end

  def filter_clique_only(elements, clique_only)
    filtered = []
    # Filtering
    elements.each do |e|
      if e.clique_only == clique_only
        filtered << e
      end
    end
    return filtered
  end
end
