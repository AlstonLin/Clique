class User < ActiveRecord::Base
  before_save :default_values
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
  validates :name, presence: true
  validates :email, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!
    end
  end

  def default_values
  end
end
