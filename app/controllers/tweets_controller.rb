class TweetsController < ApplicationController


  def new
    @pin = Pin.find_by id: params["pin_id"]
  end

  def create

    @pin = Pin.find_by id: params["pin_id"]
    current_user.tweet(twitter_params[:message])

    redirect_to tweets_show_path(request.params)

  end

  def show
    @pin = Pin.find_by id: params["pin_id"]
  end

private 


  def twitter_params
    params.require(:tweet).permit(:message, :pin_id)
  end














end
