class Repost < ActiveRecord::Base
  belongs_to :post
  belongs_to :reposter, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :post, :presence => true
  validates :reposter, :presence => true
end
