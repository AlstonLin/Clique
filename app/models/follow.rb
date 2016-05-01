class Follow < ActiveRecord::Base
  after_commit :create_notification
  # Relationships
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :following, :class_name => 'User', :foreign_key => 'following_id'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :follower, :presence => true
  validates :following, :presence => true

  private
    def create_notification
      Notification.create :notifiable => self, :user => self.following, :initiator => self.follower
    end
end
