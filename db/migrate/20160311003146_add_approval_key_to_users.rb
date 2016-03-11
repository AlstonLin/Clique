class AddApprovalKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preapprovalKey, :string
  end
end
