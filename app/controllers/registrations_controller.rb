class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:username, :bio, :email, :password, :password_confirmation, :profile_picture)
  end

  def account_update_params
    params.require(:user).permit(:username, :bio, :email, :password, :password_confirmation, :current_password, :profile_picture, :twitter, :facebook, :website)
  end



end

