class DashboardController < ApplicationController
  TOP_CLIQUES = 10
  TOP_TRACKS = 10

  def main
    @partial = "yearly"
    get_top
  end

  def monthly
    @partial = "monthly"
    get_top
    render :action => :main
  end

  def daily
    @partial = "daily"
    get_top
    render :action => :main
  end

  def tracks
  end

  def orders
  end

  # -------------------------------- HELPERS -----------------------------------
  def get_top
    @top_cliques = Cliq.order("members_count DESC").take TOP_CLIQUES
    @top_tracks = Track.order("favourites_count DESC").take TOP_TRACKS
  end
end
