class FavTracksUsers < ActiveRecord::Migration
  def change
    create_table :fav_tracks_users, :id => false do |t|
      t.integer :user_id
      t.integer :track_id
    end
  end
end
