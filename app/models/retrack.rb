class Retrack < ActiveRecord::Base
  after_commit :create_notification

  belongs_to :track
  belongs_to :reposter, :class_name => 'User'
  validates :track, :presence => true
  validates :reposter, :presence => true

  private
    def create_notification
      Notification.create :notifiable => self, :user => self.track.owner, :initiator => self.reposter
    end
end
