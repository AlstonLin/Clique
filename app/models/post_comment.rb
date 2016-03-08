class PostComment < ActiveRecord::Base
  belongs_to :post, :class_name => 'Post'
  belongs_to :creator, :class_name => 'User'
  validates :post, :presence => true
  validates :creator, :presence => true
  validates :content, :presence => true
end
