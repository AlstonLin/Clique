class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      # Basic Info
      t.string :name
      t.string :image
      t.integer :age
      t.string :gender
      t.date :birthday
      t.string :phone
      t.integer :type
      # Location
      t.string :address
      t.string :city
      t.string :country
      # Contact
      t.string :email
      t.string :twitter_name
      t.string :soundcloud_name
      t.timestamps null: false
      # OmniAuth
      t.string :provider
      t.string :uid
      # Devise
      t.string :email
      t.string :encrypted_password
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      # Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      # Lockable
      t.integer  :failed_attempts, default: 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      t.timestamps null: false
    end
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
