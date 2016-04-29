class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t
      t.timestamps null: false
    end
  end
end
