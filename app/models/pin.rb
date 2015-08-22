class Pin < ActiveRecord::Base
	Paperclip.options[:command_path] = 'C:/Program Files/ImageMagick-6.9.1-Q16'
	belongs_to :user
	validates :user_id, presence: true
	validates :price, presence: true
	validates :description, presence: true
	validates :image, presence: true
	validates :name, presence: true
	validates :download_link, presence: true

	has_attached_file :image, :styles => { :medium => "300x300>" }
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
