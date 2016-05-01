class Favourite < ActiveRecord::Base
  belongs_to :favouritable, :polymorphic => true
  belongs_to :favouriter, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :favouritable, :presence => true
  validates :favouriter, :presence => true
end
