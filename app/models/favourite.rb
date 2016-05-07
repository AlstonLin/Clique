class Favourite < ActiveRecord::Base
  after_commit :create_notification

  belongs_to :favouritable, :polymorphic => true, :counter_cache => true
  belongs_to :favouriter, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :favouritable, :presence => true
  validates :favouriter, :presence => true

  private
    def create_notification
      if self.favouriter != self.favouritable.owner
        Notification.create :notifiable => self, :user => self.favouritable.owner, :initiator => self.favouriter
      end
    end
end
