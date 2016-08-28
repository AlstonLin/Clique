class AccessCodesController < ApplicationController
  def new
    if current_user == nil || current_user.can_generate_access_codes == false
      send_401
      return
    end
    @access_code = AccessCode.new
  end

  def create
    if current_user == nil || current_user.can_generate_access_codes == false
      send_401
      return
    end
    @access_code = AccessCode.new
    @access_code.user = current_user
    @access_code.save
    respond_to do |format|
      format.js
    end
  end

  def form
  end

  def submit
    access_code = AccessCode.where(:code => params[:access_code], :created_account => nil).first
    unless access_code
      send_404
      return
    end
    session[:access_code] = access_code.code
    redirect_to new_user_registration_path
  end
end
