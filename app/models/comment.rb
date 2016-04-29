class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :creator, :class_name => 'User'
  validates :commentable, :presence => true
  validates :creator, :presence => true
  validates :content, :presence => true
end
