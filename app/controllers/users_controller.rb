class UsersController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @songs = @user.tracks
  end
  # ----------------------- Custom RESTFUL Actions-----------------------------
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

  def songs
    @user = User.find(params[:user_id])
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
end
