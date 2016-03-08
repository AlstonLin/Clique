class CreateTrackComments < ActiveRecord::Migration
  def change
    create_table :track_comments do |t|
      t.datetime :created_at
      t.text :content
      t.belongs_to :creator
      t.belongs_to :track
      t.timestamps null: false
    end
  end
end
