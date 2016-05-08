class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :favouritable, polymorphic: true, index: true
      t.belongs_to :favouriter
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
