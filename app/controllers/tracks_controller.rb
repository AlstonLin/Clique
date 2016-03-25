class TracksController < ApplicationController
  # TODO: Don't forget to use obfuscate_id on everything for security!
  
  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @track = Track.new
  end

  def show
    @track = Track.find(params[:id])
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
    @retrack = Retrack.where(:track => @track).where(:reposter => current_user)
    if @retrack.count > 0
      @retrack.first.destroy
      flash[:notice] = "Repost deleted"
    else
      @retrack = Retrack.new
      @retrack.track = @track
      @retrack.reposter = current_user
      if @retrack.save
        flash[:notice] = "Reposted!"
      else
        flash[:error] = "An Error has occured"
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def favorite
    @track = Track.find(params[:track_id])
    if @track.favoriters.include? current_user
      @track.favoriters.delete(current_user)
    else
      @track.favoriters << current_user
    end
    @favorites = current_user.get_favorites
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
