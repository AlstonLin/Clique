require "stripe"

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
    @clique.update_attributes(clique_params)
    # Response
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def show
    @clique = Cliq.find(params[:id])
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def payment
    @clique = Cliq.find(params[:cliq_id])
    @setup = !current_user.customer_id
  end

  def join
    @clique = Cliq.find(params[:cliq_id])
    join_clique @clique
  end

  def leave
    # TODO: Some kind a daemon that deletes any canceled subscriptions due to lack of payment
    @clique = Cliq.find(params[:cliq_id])
    subscriptions = Subscription.where(:subscriber => current_user).where(:clique => @clique)
    # Payment stuff
    subscriptions.each do |s|
      begin
        sub = Stripe::Subscription.retrieve(s.stripe_id)
        sub.delete :at_period_end => true
      rescue => error
        puts error
      end
      s.active = false
      s.save
    end
    # Removes and redirects
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :email, :description, :thank_you_message)
  end
end
