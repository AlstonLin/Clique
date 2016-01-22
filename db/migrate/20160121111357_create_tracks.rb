class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.attachment :song
      t.belongs_to :owner
      t.timestamps null: false
    end
  end
end
