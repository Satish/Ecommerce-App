class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users do |t|
      t.references :role, :user
      t.boolean :active, :default => true
      
      t.timestamps
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"
  end

  def self.down
    drop_table :roles_users
  end
end
