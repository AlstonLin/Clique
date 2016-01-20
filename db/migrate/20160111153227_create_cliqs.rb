class CreateCliqs < ActiveRecord::Migration
  def change
    create_table :cliqs do |t|
      # Attributes
      t.string :perks_description
      t.integer :price
      # Relations
      t.belongs_to :owner
      t.timestamps null: false
    end
  end
end
