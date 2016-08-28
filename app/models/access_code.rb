class AccessCode < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  belongs_to :created_account, :class_name => 'User'
  before_create :create_unique_identifier
  validates :user, :presence => true

  def create_unique_identifier
    begin
      self.code = SecureRandom.hex(8) # or whatever you chose like UUID tools
    end while self.class.exists?(:code => code)
  end

  def active
    return self.created_account == nil
  end
end
