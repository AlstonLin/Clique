class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.datetime :created_at
      t.belongs_to :creator
      t.timestamps null: false
    end
  end
end
