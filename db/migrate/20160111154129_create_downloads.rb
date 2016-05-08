class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.belongs_to :track, :counter_cache => true
      t.belongs_to :downloader
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
