class AddAttachmentMp3ToPins < ActiveRecord::Migration
  def self.up
    change_table :pins do |t|
      t.attachment :mp3
    end
  end

  def self.down
    remove_attachment :pins, :mp3
  end
end
