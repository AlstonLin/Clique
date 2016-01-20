class User < ActiveRecord::Base
  # Auth
  devise :omniauthable, :database_authenticatable, :confirmable, \
   :registerable, :recoverable, :rememberable, :trackable, :validatable
  def self.from_omniauth(auth)
   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.name = auth.info.name
     user.password = Devise.friendly_token[0,20]
     user.image = auth.info.image
     user.skip_confirmation!
   end
  end
end
