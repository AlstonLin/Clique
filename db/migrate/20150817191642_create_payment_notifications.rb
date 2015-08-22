class CreatePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :payment_notifications do |t|
      t.text :params
      t.string :payer_email
      t.string :first_name
      t.string :transaction_id
      t.string :create

      t.timestamps null: false
    end
  end
end
