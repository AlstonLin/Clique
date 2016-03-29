class AddEmailToCliqs < ActiveRecord::Migration
  def change
    add_column :cliqs, :email, :string
  end
end
