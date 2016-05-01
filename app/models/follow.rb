class Follow < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :following, :class_name => 'User', :foreign_key => 'following_id'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :follower, :presence => true
  validates :following, :presence => true
  validates :notification, :presence => true
end
