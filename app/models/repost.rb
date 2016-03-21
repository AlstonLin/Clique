class Repost < ActiveRecord::Base
  belongs_to :post
  belongs_to :reposter, :class_name => 'User'
  validates :post, :presence => true
  validates :reposter, :presence => true
end
