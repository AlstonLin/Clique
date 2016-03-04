class TracksController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @track = Track.new
  end

  def create
    puts params
    @track = Track.new(track_params)
    @track.owner = current_user
    if @track.save
      render json: { message: "success", fileID: @track.id }, :status => 200
    else
      render json: { error: @track.errors.full_messages.join(',')}, :status => 400
    end
  end

  # TODO: Change removed to false and not actually destroy it; just hide it
  def destroy
    @track = Track.find_by_id(params[:id])
    if @track
      @track.destroy
    end
    redirect_to current_user_path
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def repost
    @track = Track.find(params[:track_id])
    @track.reposters << current_user
    respond_to do |format|
      if @track.save
        flash[:notice] = "Reposted!"
      else
        flash[:error] = "An Error has occured"
      end
      format.js
    end
  end

  def favorite
    @track = Track.find(params[:track_id])
    @track.favorites << current_user
    respond_to do |format|
      if @track.save
        flash[:notice] = "Reposted!"
      else
        flash[:error] = "An Error has occured"
      end
      format.js
    end
  end
  # --------------------------------- Other-------------------------------------
  private
  def track_params
    params.require(:track).permit(:song, :name, :pic, :clique_only, :downloadable, :desc)
  end
end
