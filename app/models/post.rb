class Post < ActiveRecord::Base
  # Relationships
  has_and_belongs_to_many :reposters, :class_name => 'User'
  belongs_to :poster, :class_name => 'User'
end
