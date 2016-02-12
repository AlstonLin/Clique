class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.boolean :clique_only, default: false
      t.belongs_to :poster
      t.datetime :posted_time
      t.timestamps null: false
    end
  end
end
