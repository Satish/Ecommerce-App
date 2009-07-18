class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
      t.references :store
      
      t.timestamps
    end
    add_index :roles, [:store_id, :name], :name => "index_roles_on_store_id_and_name", :uniq => true
  end

  def self.down
    drop_table "roles"
  end
end