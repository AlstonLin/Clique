class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|
      t.belongs_to :reposter
      t.belongs_to :post
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
