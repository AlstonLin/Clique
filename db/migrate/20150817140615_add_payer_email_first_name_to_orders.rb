class AddPayerEmailFirstNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payer_email, :string
    add_column :orders, :first_name, :string
  end
end
