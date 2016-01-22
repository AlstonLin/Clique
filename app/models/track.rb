class Track < ActiveRecord::Base
  # Relationships
  has_attached_file :song
  belongs_to :owner, :class_name => 'User'
  # Validation
  validates_attachment_content_type :song, :content_type => [ 'audio/mpeg',
    'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]
  validates :owner, :presence => true
end
