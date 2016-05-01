include ApplicationHelper
class Post < ActiveRecord::Base
  after_commit :add_mentions
  # Sorting
  default_scope { order :created_at => :desc }
  # Relationships
  belongs_to :poster, :class_name => 'User'
  has_many :reposts
  has_many :comments, :as => :commentable, :class_name => "Comment"
  has_many :mentions, :as => :mentionable, :class_name => "Mention"
  has_many :favourites, :as => :favouritable, :class_name => "Favourite"
  # Validation
  validates :poster, :presence => true
  validates :content, :presence => true

  def add_mentions
    generate_mentions(content, self)
  end
end
