class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      #Attributes
      t.string :title
      t.string :description
      #Relationships
      t.belongs_to :from
      t.belongs_to :to
      t.timestamps null: false
    end
  end
end
