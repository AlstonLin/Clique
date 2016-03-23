class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      #Attributes
      t.text :content
      #Relationships
      t.belongs_to :creator
      t.belongs_to :conversation, touch: true
      t.datetime :created_at
      t.timestamps null: false
    end
  end
end
