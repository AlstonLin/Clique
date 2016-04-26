class HomeController < ApplicationController
  MAX_ITEMS = 20
  ITEMS_HOME = 4
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    # Reloads sidebar stuff
    @top = get_top ITEMS_HOME
    @favorites = current_user.favorite_tracks.select{ |t| !t.removed }.take ITEMS_HOME
    # Loads content variable if applicable
    if @content == nil
      @content = current_user.get_following_all
    end
    # Sets the variable determining which partial to show
    @partial = session[:partial]
    session[:partial] = nil
    if @partial == nil
      # Default is the "all" partial
      @partial = "all"
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def explore
    @top = get_top MAX_ITEMS
  end

  def all
    @partial = "all"
    index
    render :action => :index
  end

  def tracks
    @content = current_user.get_following_tracks
    session[:partial] = "tracks"
    index
    render :action => :index
  end

  def posts
    @content = current_user.get_following_posts
    session[:partial] = "posts"
    index
    render :action => :index
  end

  def cliques
    @content = []
    current_user.cliques.each do |c|
      @content = @content + c.owner.get_posts(true)
      @content = @content + c.owner.get_tracks(true)
    end
    @content = @content.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    @content = @content.first(MAX_ITEMS)

    session[:partial] = "cliques"
    index
    render :action => :index
  end

  def favorites
    @content = current_user.get_favorites
    session[:partial] = "favorites"
    index
    render :action => :index
  end

  def dashboard
  end

  def dashboard_tracks
  end

  def dashboard_orders
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
