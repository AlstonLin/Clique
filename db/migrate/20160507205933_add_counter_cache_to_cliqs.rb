class AddCounterCacheToCliqs < ActiveRecord::Migration
  def self.up
    add_column :cliqs, :members_count, :integer, :default => 0
    Cliq.find_each do |cliq|
      cliq.update_attribute(:members_count, cliq.members.count)
    end
  end

  def self.down
    remove_column :cliqs, :members_count
  end
end
