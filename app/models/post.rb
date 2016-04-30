include ApplicationHelper
class Post < ActiveRecord::Base
  after_commit :add_mentions
  
  # Sorting
  default_scope { order :created_at => :desc }
  # Relationships
  has_many :comments, :as => :commentable, :class_name => "Comment"
  has_many :mentions, :as => :mentionable, :class_name => "Mention"
  has_many :reposts
  has_and_belongs_to_many :favoriters, :class_name => 'User', :join_table => 'fav_posts_users', \
    :foreign_key => :post_id, :association_foreign_key => :user_id
  belongs_to :poster, :class_name => 'User'
  # Validation
  validates :poster, :presence => true
  validates :content, :presence => true

  def add_mentions
    generate_mentions(content, self)
  end
end
