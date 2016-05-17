require "stripe"

class CliqsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  APPLICATION_FEE_PERCENTAGE = 10
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
``
  def show
    @clique = Cliq.find(params[:id])
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def join
    @clique = Cliq.find(params[:cliq_id])
    raise "Already in Clique" if @clique.is_subscribed?(current_user)
    # Checks if payment is set up
    if current_user.customer_id
      # Follows owner
      @user = @clique.owner
      if !is_following @user
        follow = Follow.create :follower => current_user, :following => @user
      end
      # Payment stuff
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      subscription = Stripe::Subscription.create(
        :customer => current_user.customer_id,
        :plan => @clique.plan_id
      )
      # Redirect
      Subscription.create(
        :subscriber => current_user,
        :clique => @clique,
        :stripe_id => subscription.id
      )
      redirect_to @clique.owner
    else
      redirect_to payment_settings_path
    end
  end

  def leave
    @clique = Cliq.find(params[:cliq_id])
    subscriptions = Subscription.where(:subscriber => current_user).where(:clique => @clique)
    # Payment stuff
    subscriptions.each do |s|
      sub = Stripe::Subscription.retrieve(s.stripe_id)
      sub.delete
    end
    # Removes and redirects
    subscriptions.destroy_all
    redirect_to @clique.owner
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :email, :description, :thank_you_message)
  end
end
