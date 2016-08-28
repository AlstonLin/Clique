class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :strict_transport_security

  CLIQUE_SUBSCRIPTION_FAN_RANKING_POINTS = 200
  APPLICATION_FEE_PERCENTAGE = 10

  # HSTS
  def strict_transport_security
    if request.ssl?
      response.headers['Strict-Transport-Security'] = "max-age=31536000; includeSubDomains"
    end
  end

  def comment_form_id(commentable)
    return "#{commentable.class.name}-comment-form#{commentable.id}"
  end
  helper_method :comment_form_id

  def is_following(following, user=current_user)
    return Follow.where(:following => following)
      .where(:follower => user)
      .where(:active => true).count > 0
  end
  helper_method :is_following

  def get_follow(following, user=current_user)
    follows = Follow.where(:following => following).where(:follower => user)
    if follows.count == 0
      return nil
    end
    return follows[0]
  end

  def get_top(num)
    # TODO: There's probably a more efficient way of doing this
    top = User.where(:id => Follow.group(:following_id).order("count(*) desc").limit(num).count.keys)
    if top.count < num
      top = top + User.all
      top = top.select{ |t| t != current_user }.uniq.first(num)
    end
    return top
  end

  def join_clique(clique)
    # Defensive checks
    if current_user == nil
      send_401
      return
    end
    if clique == nil
      send_404
      return
    end
    raise "Already in Clique" if clique.is_subscribed?(current_user)
    # Follows owner
    @user = clique.owner
    follow = get_follow(@user)
    if follow == nil
      follow = Follow.create(:follower => current_user, :following => @user)
    end
    existing = Subscription.where(:subscriber => current_user
      ).where(:clique => clique)
    # Previously subscribed
    if existing.count > 0
      existing = existing[0]
      begin
        stripe = Stripe::Subscription.retrieve(existing.stripe_id)
      rescue => error
        puts error
      end
      if stripe && stripe.status == 'active' # Same Billing cycle; Updates subscription
        stripe.plan = clique.plan_id
        stripe.save
      # New billing cycle; Creates a new Stripe subscription
      else
        Stripe.api_key = clique.stripe_secret_key
        stripe = Stripe::Subscription.create(
          :customer => current_user.customer_id,
          :plan => clique.plan_id,
          :application_fee_percent => APPLICATION_FEE_PERCENTAGE
        )
        existing.stripe_id = stripe.id
        # Adds Fan Ranking points
        follow.fan_ranking_points += CLIQUE_SUBSCRIPTION_FAN_RANKING_POINTS
        follow.save
      end
      existing.active = true
      existing.save
    # New Subscription
    else
      # Payment stuff
      Stripe.api_key = clique.stripe_secret_key
      subscription = Stripe::Subscription.create(
        :customer => current_user.customer_id,
        :plan => clique.plan_id,
        :application_fee_percent => APPLICATION_FEE_PERCENTAGE
      )
      Subscription.create(
        :subscriber => current_user,
        :clique => clique,
        :stripe_id => subscription.id
      )
      # Adds Fan Ranking points
      follow.fan_ranking_points += CLIQUE_SUBSCRIPTION_FAN_RANKING_POINTS
      follow.save
    end
    # Sends notification to Cliq owner
    Notification.create :notifiable => clique, :user => clique.owner, :initiator => current_user
    redirect_to clique.owner
  end

  def send_401
    render :file => "public/401.html", :status => :unauthorized
  end

  def send_404
    render :file => "public/404.html", :status => :unauthorized
  end
end
