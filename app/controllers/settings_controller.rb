class SettingsController < ApplicationController
  # ----------------------- Custom RESTFUL Actions------------------------------
  def account_settings
  end

  def payment_settings
  end

  def setup_payment
    customer = Stripe::Customer.create(
      :description => "Customer for User ID##{current_user.id}",
      :source  => params[:stripeToken]
    )
    current_user.customer_id = customer.id
    current_user.save
    redirect_to payment_settings_path
  end

  def edit_profile
  end

  def orders
    @subscriptions = current_user.subscriptions
  end

  def edit_clique
    @clique = current_user.clique
  end

  def clique_members
    @clique = current_user.clique
  end

  def clique_orders
  end

  def clique_settings
    @clique = current_user.clique
    if !@clique
      @clique = Cliq.new
    end
  end
end
