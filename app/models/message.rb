class Message < ActiveRecord::Base
  # Relationships
  belongs_to :from, :class_name => 'User'
  belongs_to :to, :class_name => 'User'
  # Validation
  validates :from, :presence => true
  validates :to, :presence => true
  validates :content, :presence => true
end
