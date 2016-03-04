class RepostsUsers < ActiveRecord::Migration
  def change
    create_table :reposts_users, :id => false do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
