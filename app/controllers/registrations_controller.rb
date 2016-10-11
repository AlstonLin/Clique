class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    if verify_recaptcha
      # TODO: Remove this logic once Access Codes are removed
      access_code = AccessCode.where(:code => session[:access_code], :created_account => nil).first
      if access_code != nil
        super
        access_code.created_account = current_user
        access_code.save
        session.delete(:access_code)
      else
        send_401
        return
      end
    else
     build_resource(sign_up_params)
     clean_up_passwords(resource)
     flash.now[:alert] = "reCAPTCHA Failed."
     flash.delete :recaptcha_error
     render :new
    end
  end
  # --------------------------- Overrides --------------------------------------
  private
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.pemit(:sign_up, :keys => [:name, :first_name, :last_name, :username])
  end
end
