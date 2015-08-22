class AddUsernameBioProfilePictureCoverPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :bio, :text
    add_column :users, :profile_picture, :image
    add_column :users, :cover_picture, :image
  end
end
