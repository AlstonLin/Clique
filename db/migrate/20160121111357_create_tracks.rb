class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.attachment :song

      t.timestamps null: false
    end
  end
end
