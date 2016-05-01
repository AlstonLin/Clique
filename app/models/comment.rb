include ApplicationHelper
class Comment < ActiveRecord::Base
  after_commit :add_mentions
  # Relationships
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy
  belongs_to :creator, :class_name => 'User'
  has_many :mentions, :as => :mentionable, :class_name => "Mention"
  has_one :notification, :as => :notifiable, :class_name => "Notification"
  # Validation
  validates :commentable, :presence => true
  validates :creator, :presence => true
  validates :content, :presence => true
  
  private
    def add_mentions
      generate_mentions(content, self)
    end
end
