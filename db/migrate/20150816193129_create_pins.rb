class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :name
      t.decimal :price

      t.timestamps null: false
    end
  end
end
