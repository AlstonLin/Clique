class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.datetime :created_at
      t.text :content
      t.belongs_to :creator
      t.belongs_to :post
      t.timestamps null: false
    end
  end
end
