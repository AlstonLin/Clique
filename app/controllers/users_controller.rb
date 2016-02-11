class UsersController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @users = User.all
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(user_params)
        flash[:notice] = "Successfully Updated"
        format.js
      else
        flash[:alert] = "There was a problem while updating"
        format.js
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @songs = @user.tracks
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation)
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
    @followed = User.find(params[:user_id])
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
    @user = User.find(params[:user_id])
    @posts = []
    # Filter posts
    @user.posts.each do |post|
      if !post.clique_only
        @posts << post
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def reposts
    @user = User.find(params[:user_id])
    @reposts = @user.reposts
    respond_to do |format|
      format.js
    end
  end

  def clique
    @user = User.find(params[:user_id])
    # Filter tracks
    @songs = []
    @posts = []
    @user.tracks.each do |song|
      if song.clique_only
        @songs << song
      end
    end
    @user.posts.each do |post|
      if post.clique_only
        @posts << post
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def songs
    @debug = params[:user_id]
    @user = User.find(params[:user_id])
    # # Filter tracks
    # @songs = []
    # @user.tracks.each do |song|
    #   if !song.clique_only
    #     @songs << song
    #   end
    # end
    @songs = @user.tracks
    respond_to do |format|
      format.js
    end
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers
    respond_to do |format|
      format.js
    end
  end

  def following
    @user = User.find(params[:user_id])
    @following = @user.following
    respond_to do |format|
      format.js
    end
  end
  #---------------------EXTERNALIZED FUNCTIONS----------------------------------
	def user_params
			params.require(:user).permit(:bio)
	end
end
