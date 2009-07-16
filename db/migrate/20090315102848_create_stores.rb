class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :domain, :email, :address, :display_name, :toll_free_number, :meta_title, :google_analytics_account, :add_this_username
      t.text :description, :disable_message, :meta_description, :meta_keywords
      t.boolean :active, :default => true
      t.float :handling_fee, :default => 0.0, :precision => 8, :scale => 2
      t.datetime:deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
