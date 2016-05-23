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
    # Checks if payment is set up
    @clique = Cliq.find(params[:cliq_id])
    if !current_user.customer_id
      session[:payment_setup_redirect] = cliq_payment_path(@clique)
      redirect_to payment_settings_path
    end
  end

  def join
    @clique = Cliq.find(params[:cliq_id])
    raise "Already in Clique" if @clique.is_subscribed?(current_user)
    # Follows owner
    @user = @clique.owner
    if !is_following @user
      follow = Follow.create :follower => current_user, :following => @user
    end
    # Payment stuff
    Stripe.api_key = @clique.stripe_secret_key
    subscription = Stripe::Subscription.create(
      :customer => current_user.customer_id,
      :plan => @clique.plan_id,
      :application_fee_percent => APPLICATION_FEE_PERCENTAGE
    )
    # Redirect
    Subscription.create(
      :subscriber => current_user,
      :clique => @clique,
      :stripe_id => subscription.id
    )
    # Sends notification to Cliq owner
    Notification.create :notifiable => @clique, :user => @clique.owner, :initiator => current_user
    redirect_to @clique.owner
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
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :email, :description, :thank_you_message)
  end
end
