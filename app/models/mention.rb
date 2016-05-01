class Mention < ActiveRecord::Base
  belongs_to :mentionable, :polymorphic => true, :dependent => :destroy
  belongs_to :mentioned, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :mentionable, :presence => true
  validates :mentioned, :presence => true
end
