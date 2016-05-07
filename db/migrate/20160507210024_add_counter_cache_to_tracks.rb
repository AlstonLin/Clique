class AddCounterCacheToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :favourites_count, :integer, :default => 0
    Track.find_each do |track|
      track.update_attribute(:favourites_count, track.favourites.count)
    end
  end

  def self.down
    remove_column :tracks, :favourites_count
  end
end
