class DownloadsController < ApplicationController
  def create
    @track = Track.find(params[:track_id])
    download = Download.new
    download.downloader = current_user
    download.track = @track
    respond_to do |format|
      if download.save
        format.js
      end
    end
  end
end
