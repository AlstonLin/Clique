class SearchController < ApplicationController
  SEARCH_LIMIT = 10
  def search
    if params[:resource] == 'users'
      @results = users
      render :template => 'search/users'
    elsif params[:resource] == 'tracks'
      @results = tracks
      render :template => 'search/tracks'
    else
      raise 'Illegal Resource!'
    end
  end

  def users
    User.search(params[:query], :fields => [:first_name, :last_name, :username], :limit => SEARCH_LIMIT)
  end

  def tracks
    Track.search(params[:query], :fields => [:name, :owner], :limit => SEARCH_LIMIT)
  end
end
