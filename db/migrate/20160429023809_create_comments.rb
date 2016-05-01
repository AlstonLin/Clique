class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.datetime :created_at
      t.text :content
      t.boolean :removed, :default => false
      t.belongs_to :owner
      t.references :commentable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
