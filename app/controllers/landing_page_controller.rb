class LandingPageController < ApplicationController
  MAX_ITEMS = 20
  def index
    @top = User.where(:id => Follow.group(:following_id).order("count(*) desc").limit(MAX_ITEMS).count.keys)
  end
end
