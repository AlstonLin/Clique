class Subscription < ActiveRecord::Base
  belongs_to :clique, :class_name => 'Cliq', counter_cache: :subscription_count
  belongs_to :subscriber, :class_name => 'User'
  validates :clique, :presence => true
  validates :subscriber, :presence => true
  validates :stripe_id, :presence => true
end
