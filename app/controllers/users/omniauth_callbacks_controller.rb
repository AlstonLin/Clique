require 'rest-client'
require 'stripe'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  STRIPE_TOKEN_URL = "https://connect.stripe.com/oauth/token"
  CLIQ_SUBSCRIPTION_COST = 500

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def stripe_connect
    # Gets the token
    @clique = current_user.clique

    uid = request.env["omniauth.auth"].uid
    secret_key = request.env["omniauth.auth"].credentials.token
    publishable_key = request.env["omniauth.auth"].info.stripe_publishable_key
    # Uses the token to create a Customer object
    customer = Stripe::Customer.create(
      {:description => "Customer for User ID##{current_user.id}"},
      {:stripe_account => uid}
    )
    # Creates a plan
    Stripe.api_key = secret_key
    plan = Stripe::Plan.create(
      :amount => CLIQ_SUBSCRIPTION_COST,
      :interval => "month",
      :name => @clique.name,
      :currency => "usd",
      :id => @clique.plan_id
    )
    # Saves data to Clique
    @clique.customer_id = uid
    @clique.stripe_secret_key = secret_key
    @clique.stripe_publishable_key = publishable_key
    @clique.save

    redirect_to clique_settings_path
  end

  def failure
    redirect_to root_path
  end
end
