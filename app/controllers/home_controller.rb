class HomeController < ApplicationController
  MAX_ITEMS = 20
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @content = current_user.get_following_all
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def explore
    # TODO: There's probably a more efficient way of doing this
    @top = User.where(:id => Follow.group(:following_id).order("count(*) desc").limit(MAX_ITEMS).count.keys)
    # If there is not enough followers to fill the list, add fill it with people with none
    if @top.count < MAX_ITEMS
      @top = @top + User.all.limit(MAX_ITEMS - @top.count)
      @top = @top.uniq
    end
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
