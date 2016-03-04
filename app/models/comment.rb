class Comment < ActiveRecord::Base
  # Relationships
  belongs_to :creator, :class_name => 'User'
end
