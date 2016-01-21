class User < ActiveRecord::Base
  # Auth
  devise :omniauthable, :database_authenticatable, :confirmable, :registerable, \
  :recoverable, :rememberable, :trackable, :validatable, :lockable,
  :omniauth_providers => [:facebook]
  # Validations
  validates :email, presence: true
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!
    end
  end
end
