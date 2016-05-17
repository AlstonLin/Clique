class AddCounterCacheToCliqs < ActiveRecord::Migration
  def self.up
    add_column :cliqs, :subscription_count, :integer, :default => 0
    Cliq.find_each do |cliq|
      cliq.update_attribute(:subscription_count, cliq.subscriptions.count)
    end
  end

  def self.down
    remove_column :cliqs, :subscription_count
  end
end
