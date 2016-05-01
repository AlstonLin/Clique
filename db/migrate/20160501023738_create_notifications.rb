class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.references :notifiable, polymorphic: true, index: true
      t.belongs_to :initiator
      t.text :message
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
