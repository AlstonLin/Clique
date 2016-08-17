class DashboardController < ApplicationController
  TOP_CLIQUES = 10
  TOP_TRACKS = 10
  MAX_ITEMS_SHOWN = 25

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
    if current_user.customer_id
      charges = Stripe::Charge.list(:customer => current_user.customer_id,
      :limit => MAX_ITEMS_SHOWN)
      @charges = charges.data
    else
      @charges = []
    end
  end

  def subscriptions
    @subscriptions = []
    current_user.subscriptions.each do |s|
      stripe_sub = Stripe::Subscription.retrieve(s.stripe_id)
      @subscriptions << {:model => s, :stripe => stripe_sub}
    end
  end

  def subscribers
    @subscriptions = []
    current_user.clique.subscriptions.each do |s|
      stripe_sub = Stripe::Subscription.retrieve(s.stripe_id, :limit => MAX_ITEMS_SHOWN)
      @subscriptions << {:model => s, :stripe => stripe_sub}
    end
  end

  def account
    @partial = "edit_profile"
  end

  def edit_profile
    @partial = "edit_profile"
    render :action => :account
  end

  def change_password
    @partial = "change_password"
    render :action => :account
  end

  def clique_settings
    @clique = current_user.clique
    if !@clique
      @clique = Cliq.new
    end
    @partial = "clique_settings"
    render :action => :account
  end

  def payment_settings
    @partial = "payment_settings"
    cus_id = current_user.customer_id
    if cus_id
      @card = Stripe::Customer.retrieve(cus_id)[:sources][:data][0]
    end
    render :action => :account
  end

  def setup_payment
    # Server side validation
    if !params[:stripeToken]
      flash[:alert] = "Invalid credit card!"
      redirect_to request.referer
      raise "TEST"
      return
    end
    if params[:address].empty? || params[:city].empty? || params[:state].empty? || params[:country].empty? || params[:postal_code].empty?
      flash[:alert] = "You're missing some information"
      redirect_to request.referer
      raise "TEST"
      return
    end
    # If it's set up from Cliq payment
    if params[:cliq_id]
      @clique = Cliq.find(params[:cliq_id])
    end
    # Registers with Stripe
    customer = Stripe::Customer.create(
      :description => "Customer for User ID##{current_user.id}",
      :source  => params[:stripeToken]
    )
    # Saves info to db
    current_user.customer_id = customer.id
    current_user.address = params[:address]
    current_user.city = params[:city]
    current_user.state = params[:state]
    current_user.country = params[:country]
    current_user.postal_code = params[:postal_code]
    current_user.save
    # Redirect to appropriate place
    if @clique
      # TODO: Make this less shitty
      join_clique @clique
    else
      redirect_to payment_settings_path
    end
  end
  # -------------------------------- HELPERS -----------------------------------
  def get_top
    @top_cliques = Cliq.order("subscription_count DESC").take TOP_CLIQUES
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
      @clique_count = current_user.clique.subscription_count
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
