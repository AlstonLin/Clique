class SettingsController < ApplicationController
  # ----------------------- Custom RESTFUL Actions------------------------------
  def account_settings
  end

  def payment_settings
    if !session[:payment_setup_redirect]
      session[:payment_setup_redirect] = payment_settings_path
    end
  end

  def setup_payment
    # Resets the redirect session var
    redirect = session[:payment_setup_redirect]
    session[:payment_setup_redirect] = nil
    # Registers with Stripe
    customer = Stripe::Customer.create(
      :description => "Customer for User ID##{current_user.id}",
      :source  => params[:stripeToken]
    )
    # Saves into the db
    current_user.customer_id = customer.id
    current_user.save
    # Redirects
    if redirect
      redirect_to redirect
    else
      redirect_to request.referer
    end
  end

  def edit_profile
  end

  def edit_clique
    @clique = current_user.clique
  end

  def clique_members
    @clique = current_user.clique
  end

  def clique_settings
    @clique = current_user.clique
    if !@clique
      @clique = Cliq.new
    end
  end
end
