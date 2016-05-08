class DashboardController < ApplicationController
  TOP_CLIQUES = 10
  TOP_TRACKS = 10

  def main
    @partial = "yearly"
    get_stats(1.year.ago)
    get_top
  end

  def monthly
    @partial = "monthly"
    get_stats(1.month.ago)
    get_top
    render :action => :main
  end

  def daily
    @partial = "daily"
    get_stats(1.day.ago)
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

  def get_stats(time_ago)
    @follower_count = current_user.followers.count
    if @follower_count == 0
      @follower_gain = 0
    else
      @follower_gain = current_user.followers.\
        where("created_at >= ?", time_ago).count * 100 / @follower_count
    end

    if current_user.clique
      @clique_count = current_user.clique.members_count
    end

    @download_count = current_user.tracks.sum(:downloads_count)
    if @download_count == 0
      @download_gain = 0
    else
      @download_gain = Download.where("created_at >= ?", time_ago).\
        select{ |d| d.track.owner == current_user }.count * 100 / @download_count
    end
  end
end
