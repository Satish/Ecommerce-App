class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :type, :first_name, :last_name, :street1, :street2, :city,
               :state, :zipcode, :country, :email, :phone, :fax, :company
      t.references :addressable, :polymorphic => true
      t.boolean :default, :default => false

      t.timestamps
    end
    add_index :addresses, [:addressable_id, :addressable_type], :name => "index_addresses_on_addressable_id_and_addressable_type"
  end

  def self.down
    drop_table :addresses
  end
end
