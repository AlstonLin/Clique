class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      # Attributes
      t.string :url
      t.integer :price
      # Relationships
      t.belongs_to :owner
      t.timestamps null: false
    end
  end
end
