class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.datetime :updated_at
      t.timestamps null: false
    end
  end
end
