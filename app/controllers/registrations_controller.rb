class RegistrationsController < Devise::RegistrationsController
  def create
   if verify_recaptcha
     super
   else
     build_resource(sign_up_params)
     clean_up_passwords(resource)
     flash.now[:alert] = "reCAPTCHA Failed."
     flash.delete :recaptcha_error
     render :new
   end
 end
  private
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
