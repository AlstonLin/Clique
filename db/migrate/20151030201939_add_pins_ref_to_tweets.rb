class AddPinsRefToTweets < ActiveRecord::Migration
  def change
    add_reference :tweets, :pins, index: true, foreign_key: true
  end
end
