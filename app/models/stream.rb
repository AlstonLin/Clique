class Stream < ActiveRecord::Base
  t.string :url
  t.belongs_to :owner
end
