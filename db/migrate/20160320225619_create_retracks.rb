class CreateRetracks < ActiveRecord::Migration
  def change
    create_table :retracks do |t|
      t.belongs_to :reposter
      t.belongs_to :track
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
