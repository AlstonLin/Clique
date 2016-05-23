class AddBillingAddressToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :location
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
  end

  def self.down
    remove_column :users, :state
    remove_column :users, :postal_code
    add_column :users, :location, :string
  end
end
