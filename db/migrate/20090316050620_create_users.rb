class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :login, :crypted_password, :salt, :remember_token, :activation_code, :limit => 40
      t.string :name,                                                               :limit => 100, :default => '', :null => true
      t.string :email,                                                              :limit => 100
      t.datetime :activated_at, :remember_token_expires_at, :deleted_at, :visited_at
      t.string :state,                                                              :null => :no, :default => 'passive'
      t.references :store
      
      t.timestamps      
    end
    add_index :users, [:store_id, :login], :name => "index_users_on_store_id_and_login", :uniq => true
    add_index :users, [:store_id, :state], :name => "index_users_on_store_id_and_state"
  end

  def self.down
    drop_table "users"
  end
end
