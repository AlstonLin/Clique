class Conversation < ActiveRecord::Base
  default_scope { order :updated_at => :desc }
  has_many :messages, :class_name => 'Message'
  has_and_belongs_to_many :users, :class_name => 'User', :join_table => 'conversations_users', \
    :foreign_key => :conversation_id, :association_foreign_key => :user_id

  def get_name (current_user)
    if self.name
      return name
    end
    name = "Conversation with"
    first = true
    self.users.each do |u|
      if u != current_user
        if first
          first = false
          name += " " + u.name
        else
          name += " and " + u.name
        end
      end
    end
    return name
  end

  def image_url (current_user)
    other = self.users.select { |u| u != current_user }
    return other[0].profile_picture_url
  end
end
