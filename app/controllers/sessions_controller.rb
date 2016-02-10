class SessionsController < Devise::SessionsController
  def create
    user = User.omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url
  end
end
