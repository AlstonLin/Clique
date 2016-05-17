class Cliq < ActiveRecord::Base
  FEE = 0.06
  after_create :generate_name
  # Relationships
  belongs_to :owner, :class_name => 'User'
  has_many :subscriptions, :class_name => 'Subscription'
  # Validations
  validates :owner, :presence => true
  # validates :price, :presence => true
  # ---------------------------- Helper Functions ------------------------------
  def generate_name
    if !self.name
      self.name = self.owner.first_name + " " + self.owner.last_name + "'s Clique"
    end
  end

  def plan_id
    "#{self.created_at.to_s(:number)}-#{self.id}"
  end

  def is_subscribed?(user)
    Subscription.where(:subscriber => user).where(:clique => self).count > 0
  end
end
