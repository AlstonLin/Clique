include ApplicationHelper

class User < ActiveRecord::Base
  MAX_ITEMS = 20
  after_initialize :default_values
  after_commit :generate_urls
  after_create :generate_username
  # Relationships
  has_one :clique, :class_name => "Cliq", :foreign_key => 'owner_id'
  has_many :downloaded, :class_name => 'Download', :foreign_key => 'downloader_id'
  has_many :following, :class_name => 'Follow', :foreign_key => 'follower_id'
  has_many :followers, :class_name => 'Follow', :foreign_key => 'following_id'
  has_many :tracks, :class_name => 'Track', :foreign_key => 'owner_id'
  has_many :posts, :class_name => 'Post', :foreign_key => 'owner_id'
  has_many :post_comments, :class_name => 'PostComment'
  has_many :track_comments, :class_name => 'TrackComment'
  has_many :reposts, :class_name => 'Repost', :foreign_key => 'reposter_id'
  has_many :retracks, :class_name => 'Retrack', :foreign_key => 'reposter_id'
  has_many :messages, :class_name => 'Message', :foreign_key => 'creator_id'
  has_many :mentions, :class_name => 'Mention', :foreign_key => 'mentioned_id'
  has_many :notifications, :class_name => 'Notification', :foreign_key => 'user_id'
  has_many :notifications_initiated, :class_name => 'Notification', :foreign_key => 'initiator_id'
  has_many :favourites, :class_name => 'Favourite', :foreign_key => 'favouriter_id'
  has_many :subscriptions, :class_name => 'Subscription', :foreign_key => 'subscriber_id'
  has_and_belongs_to_many :conversations, :class_name => 'Conversation', :join_table => 'conversations_users', \
    :foreign_key => :user_id, :association_foreign_key => :conversation_id
  # Pictures
  has_attached_file :profile_picture, :styles => { small: "200x200", med: "500x500", large: "800x800",
                  :url  => "/assets/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension" },
                  :s3_protocol => :https
  has_attached_file :cover_picture, :styles => { small: "640x480", med: "1280x720", large: "1920x1080",
                  :url  => "/assets/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension" },
                  :s3_protocol => :https
  # Auth
  devise :omniauthable, :database_authenticatable, :registerable, \
  :recoverable, :rememberable, :trackable, :validatable, :lockable,
  :omniauth_providers => [:facebook, :stripe_connect]
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :profile_picture_url, presence: true
  validates :cover_picture_url, presence: true
  validates :username, :uniqueness => {:case_sensitive => false}, presence: false
  validates_attachment_size :profile_picture, :cover_picture, :less_than => 25.megabytes
  validates_attachment_size :cover_picture, :cover_picture, :less_than => 25.megabytes
  validates_attachment_content_type :profile_picture, :content_type => ['image/jpeg', 'image/png']
  validates_attachment_content_type :cover_picture, :content_type => ['image/jpeg', 'image/png']

  # Auth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.password = Devise.friendly_token[0,20]
      user.profile_picture_url = convert_to_https(auth.info.image)
    end
  end

  # ---------------------------- Methods ---------------------------------------
  def name
    self.first_name + " " + self.last_name
  end

  def has_reposted?(post)
    return Repost.where(:post => post).where(:reposter => self).count > 0
  end

  def has_retracked?(track)
    return Retrack.where(:track => track).where(:reposter => self).count > 0
  end

  def get_posts(clique_only)
    posts = filter_clique_only(self.posts, clique_only) + filter_clique_only_reposts(self.reposts, clique_only)
    return posts.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}.first(MAX_ITEMS)
  end

  def get_tracks(clique_only)
    tracks = filter_clique_only(self.tracks, clique_only) + filter_clique_only_retracks(self.retracks, clique_only)
    return tracks.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}.first(MAX_ITEMS)
  end

  def get_favorites(limit=MAX_ITEMS)
    return self.favourites.select { |f| !f.favouritable.removed }.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}.first(limit).map(&:favouritable)
  end

  def get_following_all
    content = self.tracks.select { |t| !t.removed} + self.posts.select { |p| !p.removed }
    self.following.each do |f|
      following = f.following
      if following.clique && following.clique.is_subscribed?(self)
        content = content + filter_clique_only(following.posts + following.tracks, nil)
      else
        content = content + filter_clique_only(following.posts + following.tracks, false)
      end
      content = content + filter_clique_only_reposts(following.reposts, false)
      content = content + filter_clique_only_retracks(following.retracks, false)
    end
    content = content.sort { |e1, e2| e2[:created_at] <=> e1[:created_at] }
    return content.first(MAX_ITEMS)
  end

  def get_following_tracks
    tracks = self.tracks.select { |t| !t.removed }
    self.following.each do |f|
      following = f.following
      if following.clique && following.clique.is_subscribed?(self)
        tracks = tracks + filter_clique_only(following.tracks, nil)
      else
        tracks = tracks + filter_clique_only(following.tracks, false)
      end
      tracks = tracks + filter_clique_only_retracks(following.retracks, false)
    end
    tracks = tracks.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    return tracks.first(MAX_ITEMS)
  end

  def get_following_posts
    posts = self.posts.select { |p| !p.removed }
    self.following.each do |f|
      following = f.following
      if following.clique && following.clique.is_subscribed?(self)
        posts = posts + filter_clique_only(following.posts, nil)
      else
        posts = posts + filter_clique_only(following.posts, false)
      end
      posts = posts + filter_clique_only_reposts(following.reposts, false)
    end
    posts = posts.sort {|e1, e2| e2[:created_at] <=> e1[:created_at]}
    return posts.first(MAX_ITEMS)
  end

  def to_param
    username
  end
  # ------------------------------- Private  -----------------------------------
  private
    def filter_clique_only(elements, clique_only)
      return elements.select{ |e| !e.removed && (clique_only == nil || e.clique_only == clique_only) }
    end

    def filter_clique_only_reposts(reposts, clique_only)
      return reposts.select{ |e| !e.post.removed && (clique_only == nil || e.post.clique_only == clique_only) }
    end

    def filter_clique_only_retracks(retracks, clique_only)
      return retracks.select{ |e| !e.track.removed && (clique_only == nil || e.track.clique_only == clique_only) }
    end

    def default_values
      if !self.profile_picture_url
        self.profile_picture_url = ActionController::Base.helpers.asset_path("default-profile.jpg")
      end
      if !self.cover_picture_url
        self.cover_picture_url = ActionController::Base.helpers.asset_path("default-cover.png")
      end
    end

    def generate_username
      if !self.username
        self.username = self.first_name + self.last_name + self.id.to_s
        self.save
      end
    end

    def generate_urls
      if self.profile_picture.exists?
        self.update_column(:profile_picture_url, self.profile_picture.url(:med))
      end
      if self.cover_picture.exists?
        self.update_column(:cover_picture_url, self.cover_picture.url(:med))
      end
    end
end
