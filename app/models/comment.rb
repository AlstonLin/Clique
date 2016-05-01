include ApplicationHelper
class Comment < ActiveRecord::Base
  after_commit :add_mentions, :create_notification
  # Relationships
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy
  belongs_to :owner, :class_name => 'User'
  has_many :mentions, :as => :mentionable, :class_name => "Mention"
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  # Validation
  validates :commentable, :presence => true
  validates :owner, :presence => true
  validates :content, :presence => true

  private
    def add_mentions
      generate_mentions(content, self)
    end

    def create_notification
      if self.owner != self.commentable.owner
        Notification.create :notifiable => self, :user => self.commentable.owner, :initiator => self.owner
      end
    end
end
