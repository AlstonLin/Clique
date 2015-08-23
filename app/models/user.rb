class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins
  validates :username, presence: true, length: { maximum: 140 }
  validates :bio, presence: true, length: { maximum: 140 }
  validates_uniqueness_of :username
  has_attached_file :profile_picture, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/

end
