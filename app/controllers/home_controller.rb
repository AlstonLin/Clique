class HomeController < ApplicationController
  MAX_ITEMS = 20
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @tracks = Track.where(:clique_only => false).limit(MAX_ITEMS)
  end
  # ----------------------- Custom RESTFUL Actions-----------------------------
  def explore
    @tracks = Track.where(:clique_only => false).limit(MAX_ITEMS)
    respond_to do |format|
      format.js
    end
  end

  def posts
    @posts = Post.where(:clique_only => false).limit(MAX_ITEMS)
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
