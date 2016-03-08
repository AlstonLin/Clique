class TrackComment < ActiveRecord::Base
  belongs_to :track, :class_name => 'Track'
  belongs_to :creator, :class_name => 'User'
  validates :track, :presence => true
  validates :creator, :presence => true
  validates :content, :presence => true
end
