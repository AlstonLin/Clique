class Post < ActiveRecord::Base
  # Sorting
  default_scope { order :created_at => :desc }
  # Relationships
  has_and_belongs_to_many :reposters, :class_name => 'User', :join_table => 'reposts_users', \
    :foreign_key => :post_id, :association_foreign_key => :user_id
  has_and_belongs_to_many :favoriters, :class_name => 'User', :join_table => 'fav_posts_users', \
    :foreign_key => :post_id, :association_foreign_key => :user_id
  belongs_to :poster, :class_name => 'User'
  # Validation
  validates :poster, :presence => true
  validates :content, :presence => true
end
