class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.attachment :song
      t.belongs_to :owner
      t.boolean :clique_only, default: false
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
