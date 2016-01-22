class TracksController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def index
    @tracks = Track.all
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)
    @track.owner = current_user
    if @track.save
      render json: { message: "success", fileID: @track.id }, :status => 200
    else
      render json: { error: @track.errors.full_messages.join(',')}, :status => 400
    end
  end
  # ----------------------- Custom RESTFUL Actions-----------------------------
  def explore
    # TODO: Somehow find what to show them?
    @tracks = Track.all
    respond_to do |format|
      format.js
    end
  end

  def followed
    @following = current_user.following
    respond_to do |format|
      format.js
    end
  end

  def cliques
    @cliques = current_user.cliques
    respond_to do |format|
      format.js
    end
  end
  # --------------------------------- Other-------------------------------------
  private
  def track_params
    params.require(:track).permit(:song)
  end
end
