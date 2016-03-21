class Track < ActiveRecord::Base
  # Sorting
  default_scope { order :created_at => :desc }
  # Relationships
  has_attached_file :song
  has_attached_file :pic
  belongs_to :owner, :class_name => 'User'
  has_many :comments, :class_name => 'TrackComment'
  has_many :retracks
  has_and_belongs_to_many :favoriters, :class_name => 'User', :join_table => 'fav_tracks_users', \
    :foreign_key => :track_id, :association_foreign_key => :user_id
  # Validation
  validates_attachment_content_type :song, :content_type => [ 'audio/mpeg',
    'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]
  validates :owner, :presence => true
  validates :name, :presence => true
end
