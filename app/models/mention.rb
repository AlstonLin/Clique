class Mention < ActiveRecord::Base
  after_commit :create_notification

  belongs_to :mentionable, :polymorphic => true, :dependent => :destroy
  belongs_to :mentioned, :class_name => 'User'
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  validates :mentionable, :presence => true
  validates :mentioned, :presence => true

  private
    def create_notification
      if self.mentioned != self.mentionable.owner
        Notification.create :notifiable => self, :user => self.mentioned, :initiator => self.mentionable.owner
      end
    end
end
