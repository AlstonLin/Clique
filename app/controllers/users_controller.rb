class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
end
