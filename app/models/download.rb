class Download < ActiveRecord::Base
  belongs_to :track, :class_name => "Track", :counter_cache => true
  belongs_to :downloader, :class_name => "User"
  validates :track, :presence => true
  validates :downloader, :presence => true
end
