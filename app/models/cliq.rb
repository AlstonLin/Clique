class Cliq < ActiveRecord::Base
  FEE = 0.06
  after_create :generate_name
  # Relationships
  belongs_to :owner, :class_name => 'User'
  has_and_belongs_to_many :members, :class_name => 'User', :uniq => true
  # Validations
  validates :owner, :presence => true
  # validates :price, :presence => true
  validates :email, :presence => true
  # ---------------------------- Helper Functions ------------------------------
  def generate_name
    if !self.name
      self.name = self.owner.first_name + " " + self.owner.last_name + "'s Clique"
    end
  end
end
