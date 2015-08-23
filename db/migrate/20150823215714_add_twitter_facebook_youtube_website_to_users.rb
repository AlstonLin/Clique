class AddTwitterFacebookYoutubeWebsiteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :youtube, :string
    add_column :users, :website, :string
  end
end
