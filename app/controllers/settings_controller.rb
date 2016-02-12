class SettingsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def change_password
    respond_to do |format|
      format.js
    end
  end

  def clique_settings
    @clique = current_user.clique
    if !@clique
      @clique = Cliq.new
    end
    respond_to do |format|
      format.js
    end
  end

  def edit_profile
    respond_to do |format|
      format.js
    end
  end

  def orders
    respond_to do |format|
      format.js
    end
  end

  def payment_settings
    respond_to do |format|
      format.js
    end
  end
end
