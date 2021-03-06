class CreateShippingMethods < ActiveRecord::Migration
  def self.up
    create_table :shipping_methods do |t|
      t.string      :name
      t.references  :store
      t.string     :status, :default => 'Active', :limit => '10'

      t.timestamps
    end
    add_index :shipping_methods, :store_id
    add_index :shipping_methods, :status
  end

  def self.down
    drop_table :shipping_methods
  end
end