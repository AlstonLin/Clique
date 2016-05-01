class Notification < ActiveRecord::Base
  # Relationships
  belongs_to :user, :class_name => 'User'
  belongs_to :initiator, :class_name => 'User'
  belongs_to :notifiable, :polymorphic => true
  # Validation
  validates :notifiable, :presence => true
  validates :user, :presence => true
  validates :initiator, :presence => true
  validates :message, :presence => true
end
