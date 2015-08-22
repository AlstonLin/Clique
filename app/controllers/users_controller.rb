class UsersController < ApplicationController
	def show
  		@user = User.find(params[:id])
  		render :layout => false
	end

	def index 
		@users = User.all 
	end

end
