class Track < ActiveRecord::Base
  # Relationships
  has_attached_file :song, :s3_protocol => :https
  has_attached_file :pic, :s3_protocol => :https
  belongs_to :owner, :class_name => 'User'
  has_many :retracks
  has_many :downloads
  has_many :comments, :as => :commentable, :class_name => "Comment"
  has_many :favourites, :as => :favouritable, :class_name => "Favourite"
  # Validation
  validates_attachment_content_type :song, :content_type => [ 'audio/mpeg',
    'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]
  validates :owner, :presence => true
  validates :name, :presence => true

  def get_pic_url
    if pic.exists? then pic.url else ActionController::Base.helpers.asset_path("default-track.png") end
  end
end
