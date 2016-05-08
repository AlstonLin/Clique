class CliqsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @clique = Cliq.new
  end

  def create
    # Creates Clique
    @clique = Cliq.new(clique_params)
    @clique.owner = current_user
    # Saves and Redirects
    if @clique.save
      flash[:notice] = "Clique Created!"
    else
      flash[:alert] = "There was an error while creating your Clique"
    end
    redirect_to clique_settings_path
  end

  def update
    @clique = Cliq.find(params[:id])
    respond_to do |format|
      if @clique.update_attributes(clique_params)
        flash[:notice] = "Clique Updated!"
        format.js
      else
        flash[:alert] = "There was an error while updating your Clique"
        format.js
      end
    end
  end

  def show
    @clique = Cliq.find(params[:id])
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def join
    @clique = Cliq.find(params[:cliq_id])
    raise "Already in Clique" if current_user.cliques.include? @clique
    # Follows owner
    @user = @clique.owner
    if !is_following @user
      follow = Follow.create :follower => current_user, :following => @user
    end
    # Payment stuff
    # Redirect
    joined # TODO: Have a callback call this
  end

  def joined
    # Joins cliq and redirects
    @clique.members << current_user
    redirect_to @clique.owner
  end


  def leave
    @clique = Cliq.find(params[:cliq_id])
    # Payment stuff
    # Removes and redirects
    @clique.members.delete(current_user)
    redirect_to @clique.owner
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :email, :description, :thank_you_message)
  end
end
