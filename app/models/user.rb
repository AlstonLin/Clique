class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins
  
  validates :username, presence: true, length: { maximum: 14 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates_uniqueness_of :username


  has_attached_file :profile_picture, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/
  crop_attached_file :profile_picture

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]
  
  def should_generate_new_friendly_id?
    new_record?
  end

def self.from_omniauth(auth)
  user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.provider = auth.provider 
    user.uid      = auth.uid
    user.username     = auth.info.nickname
    user.oauth_token = auth.credentials.token
    user.oauth_secret = auth.credentials.secret
    user.save
    user
  end
end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end



  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret)
    end
  end

  def tweet(tweet)
    client = Twitter::REST::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret) do |config|
      config.consumer_key        = "zgMv11O8r75NaVD1akKRLJm67"
      config.consumer_secret     = "GoNaWSe2t0OzFMhKWJrnLjsxRWwQg7xMtvNwlhWhmJhWPM4A8v"
      config.access_token        = oauth_token
      config.access_token_secret = oauth_secret
    end
    
    client.update(tweet)
  end

end

