class TracksController < ApplicationController
  MAX_ITEMS_MORE = 4
  # TODO: Don't forget to use obfuscate_id on everything for security!

  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @track = Track.new
  end

  def show
    @track = Track.find(params[:id])

    if @track == nil
      send_404
      return
    end

    @more = @track.owner.tracks.select{ |t| t != @track && !t.removed }.take(MAX_ITEMS_MORE)
  end

  def create
    if current_user == nil
      send_401
      return
    end

    @track = Track.new(track_params)
    @track.owner = current_user
    if @track.save
      render json: { message: "success", fileID: @track.id }, :status => 200
    else
      render json: { error: @track.errors.full_messages.join(',')}, :status => 400
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def delete
    @track = Track.find_by_id(params[:track_id])

    if @track == nil
      send_404
      return
    end

    unless @track.owner == current_user
      send_401
      return
    end

    @track.removed = true
    @track.save
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end
  # ----------------------- Custom RESTFUL Actions------------------------------

  # Remark: This controller is almost the exact same as Posts. Look into externalizing code
  def repost
    @track = Track.find(params[:track_id])

    if @track == nil
      send_404
      return
    end

    if current_user == nil
      send_401
      return
    end

    @retrack = Retrack.where(:track => @track).where(:reposter => current_user)
    if @retrack.count > 0
      @retrack.first.destroy
      flash[:notice] = "Repost deleted"
    else
      if Retrack.create :track => @track, :reposter => current_user
        flash[:notice] = "Reposted!"
      else
        flash[:error] = "An Error has occured"
      end
    end
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def favorite
    @track = Track.find(params[:track_id])

    if @track == nil
      send_404
      return
    end

    if current_user == nil
      send_401
      return
    end
    
    favourite = Favourite.where(:favouritable => @track, :favouriter => current_user)
    if favourite.count > 0
      if favourite[0].destroy
        flash[:notice] = "Unfavorited!"
      else
        flash[:error] = "An error has occured"
      end
    else
      favourite = Favourite.new :favouritable => @track, :favouriter => current_user
      if favourite.save
        flash[:notice] = "Unfavorited!"
      else
        flash[:error] = "An error has occured"
      end
    end
    respond_to do |format|
      format.js { render 'shared/reload.js.erb' }
    end
  end

  def load_modal
    @track = Track.find(params[:track_id])
    respond_to do |format|
      format.js
    end
  end
  # --------------------------------- Other-------------------------------------
  private
  def track_params
    params.require(:track).permit(:song, :name, :pic, :clique_only, :downloadable, :desc)
  end
end
