class PasswordsController < Devise::PasswordsController
  def create
   if verify_recaptcha
     super
   else
     flash[:alert] = "reCAPTCHA Failed."
     redirect_to action: 'new'
   end
 end
end
