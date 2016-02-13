class HomeController < ApplicationController
  MAX_ITEMS = 20
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @tracks = []
    current_user.following.each do |f|
      @tracks = @tracks + f.following.get_tracks(false)
    end
    @tracks = @tracks.first(MAX_ITEMS)
  end

  def explore
    @top = User.where(:id => Follow.group(:following_id).order("count(*) desc").limit(MAX_ITEMS).count.keys)
  end
  # ----------------------- Custom RESTFUL Actions-----------------------------
  def tracks
    @tracks = []
    current_user.following.each do |f|
      @tracks = @tracks + f.following.get_tracks(false)
    end
    @tracks = @tracks.first(MAX_ITEMS)
    respond_to do |format|
      format.js
    end
  end

  def posts
    @posts = []
    current_user.following.each do |f|
      @posts = @posts + f.following.get_posts(false)
    end
    @posts = @posts.first(MAX_ITEMS)
    respond_to do |format|
      format.js
    end
  end

  def cliques
    @content = []
    current_user.cliques.each do |c|
      @content = @content + c.owner.get_posts(true)
      @content = @content + c.owner.get_tracks(true)
    end
    @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    @content = @content.first(MAX_ITEMS)
    respond_to do |format|
      format.js
    end
  end
end
