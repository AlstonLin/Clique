require 'rest-client'
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  STRIPE_TOKEN_URL = "https://connect.stripe.com/oauth/token"

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
    @user = current_user
    access_code = request.params["code"]
    puts "--------------ACCESS CODE-----------------"
    puts access_code
    # Uses access code to create token
    response = RestClient.post(STRIPE_TOKEN_URL, {
      :params => {
        :client_secret => ENV['CLIQUE_STRIPE_SECRET'],
        :grant_type => 'authorization_code',
        :code => access_code
      }
    })
    puts "---------------RESPONSE-----------------------"
    puts response
    # Uses the token to create a Customer object
    # Saves the customer id to the database
  end

  def failure
    redirect_to root_path
  end
end
