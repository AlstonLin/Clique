class Message < ActiveRecord::Base
  default_scope { order :created_at => :desc }
  # Relationships
  belongs_to :creator, :class_name => 'User'
  belongs_to :conversation, :class_name => 'Conversation'
  # Validation
  validates :creator, :presence => true
  validates :content, :presence => true
end
