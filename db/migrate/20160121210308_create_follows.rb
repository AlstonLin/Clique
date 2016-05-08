class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.belongs_to :follower
      t.belongs_to :following
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
