class TracksController < ApplicationController
  def index
    @tracks = Track.all
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      render json: { message: "success", fileID: @track.id }, :status => 200
    else
      render json: { error: @track.errors.full_messages.join(',')}, :status => 400
    end
  end
  private
  def track_params
    params.require(:track).permit(:song)
  end
end
