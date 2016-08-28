class CreateAccessCodes < ActiveRecord::Migration
  def change
    create_table :access_codes do |t|
      t.belongs_to :user
      t.belongs_to :created_account
      t.string :code, :index => true
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps null: false
    end
  end
end
