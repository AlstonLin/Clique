class AddDescriptionDownloadLinkToPins < ActiveRecord::Migration
  def change
    add_column :pins, :description, :text
    add_column :pins, :download_link, :string
  end
end
