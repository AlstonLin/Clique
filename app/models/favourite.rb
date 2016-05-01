class Favourite < ActiveRecord::Base
  belongs_to :favouritable, :polymorphic => true
  belongs_to :favouriter, :class_name => 'User'
end
