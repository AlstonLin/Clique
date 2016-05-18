class AddCounterCacheToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :favourites_count, :integer, :default => 0
    Post.find_each do |post|
      post.update_attribute(:favourites_count, post.favourites.count)
    end
  end

  def self.down
    remove_column :posts, :posts_count
  end
end
