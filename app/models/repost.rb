class Repost < ActiveRecord::Base
  after_commit :create_notification

  belongs_to :post
  belongs_to :reposter, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :post, :presence => true
  validates :reposter, :presence => true

  private
    def create_notification
      Notification.create :notifiable => self, :user => self.post.owner, :initiator => self.reposter
    end
end
