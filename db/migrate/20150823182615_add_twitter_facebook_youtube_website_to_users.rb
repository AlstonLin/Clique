class AddTwitterFacebookYoutubeWebsiteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter, :url
    add_column :users, :facebook, :url
    add_column :users, :youtube, :url
    add_column :users, :website, :url
  end
end
