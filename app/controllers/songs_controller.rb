class SongsController < ApplicationController
  def new
    @song = Song.new
  end
end
