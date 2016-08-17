class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :clique
      t.belongs_to :subscriber
      t.string :stripe_id
      t.datetime :created_at
      t.boolean :active, :default => true
      t.timestamps null: false
    end
  end
end
