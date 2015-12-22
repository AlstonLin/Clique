class UsersController < ApplicationController
	def show
  		@user = User.friendly.find(params[:id]) 
  		render :layout => false
  		@pins = Pin.all.order("created_at DESC")

	end

	def index 
		@users = User.all

	end

	def followers

  		render :layout => false
	end

end
