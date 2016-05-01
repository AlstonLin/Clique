class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :favouritable, polymorphic: true, index: true
      t.belongs_to :favouriter
      t.timestamps null: false
    end
  end
end
