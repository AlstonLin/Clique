class CliqUsers < ActiveRecord::Base
  belongs_to :cliq
  belongs_to :user, counter_cache: :members_count
end
