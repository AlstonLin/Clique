class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy
  belongs_to :creator, :class_name => 'User'
  has_many :mention, :as => :mentionable, :class_name => "Mention"
  validates :commentable, :presence => true
  validates :creator, :presence => true
  validates :content, :presence => true
end
