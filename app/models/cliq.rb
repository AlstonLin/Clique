class Cliq < ActiveRecord::Base
  # Relationships
  belongs_to :owner, :class_name => 'User'
  has_many :subscriptions, :class_name => 'Subscription', :foreign_key => 'clique_id'
  # Validations
  validates :owner, :presence => true
  validates :name, length: { maximum: 38}
  validates :name, :presence => true
  # validates :price, :presence => true
  # ---------------------------- Helper Functions ------------------------------

  def plan_id
    "#{self.created_at.to_s(:number)}-#{self.id}"
  end

  def is_subscribed?(user)
    Subscription.where(:subscriber => user).where(:clique => self).count > 0
  end

  # def get_default_name
  #   self.name = self.owner.first_name + " " + self.owner.last_name + "'s Clique"
  # end

  # private
  #   def generate_name
  #     if !self.name
  #       self.name = get_default_name
  #       self.save
  #     end
  #   end
end
