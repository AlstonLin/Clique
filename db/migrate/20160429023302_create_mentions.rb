class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.timestamps null: false
      t.references :mentionable, polymorphic: true, index: true
      t.belongs_to :mentioned
    end
  end
end
