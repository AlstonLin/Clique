class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins
  





  validates :username, presence: true, length: { maximum: 14 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates :bio, presence: true, length: { maximum: 140 }
  validates_uniqueness_of :username
  validates :profile_picture, presence: true







  has_attached_file :profile_picture, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/
  crop_attached_file :profile_picture



  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]
  
  def should_generate_new_friendly_id?
    new_record?
  end
end

