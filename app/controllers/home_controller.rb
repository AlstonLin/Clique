class HomeController < ApplicationController
  MAX_ITEMS = 20
  ITEMS_HOME = 4
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @content = current_user.get_following_all
    @top = get_top ITEMS_HOME
    @favorites = current_user.favorite_tracks.select{ |t| !t.removed }.take ITEMS_HOME
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def explore
    @top = get_top MAX_ITEMS
  end

  def all
    @content = current_user.get_following_all
    respond_to do |format|
      format.js
    end
  end

  def tracks
    @tracks = current_user.get_following_tracks
    respond_to do |format|
      format.js
    end
  end

  def posts
    @posts = current_user.get_following_posts
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

  def favorites
    @favorites = current_user.get_favorites
    respond_to do |format|
      format.js
    end
  end


  def notifications
  end

  def payment
  end



  # -------------------- EXTERNALIZED FUNCTIONS --------------------------------
  private
    def get_tracks
      @tracks = []
      # Generates a list of Tracks from all users being followed
      current_user.following.each do |f|
        @tracks = @tracks + f.following.get_tracks(false)
      end
      # Gets the first MAX_ITEMS items
      @tracks = @tracks.first(MAX_ITEMS)
    end
end
