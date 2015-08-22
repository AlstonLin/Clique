class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins
  validates :username, presence: true
  has_attached_file :profile_picture, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/
  attr_accessible :username, :email, :password, :password_confirmation, :remember_token
end
