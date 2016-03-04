class RetracksUsers < ActiveRecord::Migration
  def change
    create_table :retracks_users, :id => false do |t|
      t.integer :user_id
      t.integer :track_id
    end
  end
end
