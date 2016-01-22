class CliqsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @clique = Cliq.new
  end

  def create
    raise "You already have a Clique" unless !current_user.clique
    @clique = Cliq.new
    @clique.owner = current_user
    if @clique.save
      flash[:notice] = "Clique Created!"
      redirect_to @clique
    else
      flash[:error] = "There was an error while creating your Clique"
      redirect_to new_cliq_path
    end
  end

  def show
    @clique = Cliq.find(params[:id])
  end
  # ----------------------- Custom RESTFUL Actions-----------------------------
  def join
    @clique = Cliq.find(params[:cliq_id])
    raise "Already in Clique" unless !(current_user.cliques.include? @clique)
    # TODO: Add some kind of payment thing and validation
    @clique.members << current_user
    # Response
    respond_to do |format|
      if @clique.save
        flash[:notice] = "Joined " + @clique.owner.name + "'s Clique"
      else
        flash[:error] = "An error has occured"
      end
      format.js
    end
  end
end
