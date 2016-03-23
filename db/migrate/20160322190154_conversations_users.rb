class ConversationsUsers < ActiveRecord::Migration
  def change
    create_table :conversations_users, :id => false do |t|
      t.integer :user_id
      t.integer :conversation_id
    end
  end
end
