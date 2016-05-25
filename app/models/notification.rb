class Notification < ActiveRecord::Base
  # Sorting
  default_scope { order :created_at => :desc }
  # Relationships
  belongs_to :user, :class_name => 'User'
  belongs_to :initiator, :class_name => 'User'
  belongs_to :notifiable, :polymorphic => true, dependent: :destroy
  # Validation
  validates :notifiable, :presence => true
  validates :user, :presence => true
  validates :initiator, :presence => true
end
