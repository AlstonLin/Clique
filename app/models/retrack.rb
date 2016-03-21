class Retrack < ActiveRecord::Base
  belongs_to :track
  belongs_to :reposter, :class_name => 'User'
  validates :track, :presence => true
  validates :reposter, :presence => true
end
