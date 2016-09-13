class AddPlayCountToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :play_count, :integer, :default => 0
  end

  def self.down
    remove_column :tracks, :play_count
  end
end
