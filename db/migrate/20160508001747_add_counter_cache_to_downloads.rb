class AddCounterCacheToDownloads < ActiveRecord::Migration
  def self.up
    add_column :tracks, :downloads_count, :integer, :default => 0
    Track.find_each do |track|
      track.update_attribute(:downloads_count, track.downloads.count)
    end
  end

  def self.down
    remove_column :tracks, :downloads_count
  end
end
