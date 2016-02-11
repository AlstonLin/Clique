class User < ActiveRecord::Base
  after_initialize :default_values
  after_create :generate_username
  # Relationships
  has_one :clique, :class_name => "Cliq", :foreign_key => 'owner_id'
  has_many :following, :class_name => 'Follow', :foreign_key => 'follower_id'
  has_many :followers, :class_name => 'Follow', :foreign_key => 'following_id'
  has_many :tracks, :foreign_key => 'owner_id'
  has_many :posts, :class_name => 'Post', :foreign_key => 'poster_id'
  has_and_belongs_to_many :reposts, :class_name => 'Post'
  has_and_belongs_to_many :cliques, :class_name => 'Cliq'
  # Auth
  devise :omniauthable, :database_authenticatable, :confirmable, :registerable, \
  :recoverable, :rememberable, :trackable, :validatable, :lockable,
  :omniauth_providers => [:facebook]
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :profile_picture_url, presence: true
  validates :cover_picture_url, presence: true

  # Auth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.password = Devise.friendly_token[0,20]
      user.profile_picture_url = auth.info.image
      user.skip_confirmation!
    end
  end

  # ---------------------------- Helper Functions ------------------------------
  def generate_username
    self.username = self.first_name + self.last_name + self.id.to_s
    self.save
  end

  def default_values
    if !self.profile_picture_url
      self.profile_picture_url = ActionController::Base.helpers.asset_path("default-profile.jpg")
    end
    if !self.cover_picture_url
      self.cover_picture_url = ActionController::Base.helpers.asset_path("default-cover.png")
    end
  end

  def to_param
    username
  end
end
