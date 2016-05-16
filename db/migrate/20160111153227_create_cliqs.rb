class CreateCliqs < ActiveRecord::Migration
  def change
    create_table :cliqs do |t|
      # Payment
      t.string :customer_id
      t.string :stripe_secret_key
      t.string :stripe_publishable_key
      # Attributes
      t.string :name
      t.text :description
      t.text :thank_you_message
      t.decimal :price, :precision => 8, :scale => 2
      # Relations
      t.belongs_to :owner

      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
