class CreateStoreGateways < ActiveRecord::Migration
  def self.up
    create_table :store_gateways do |t|
      t.references :store, :gateway
      t.boolean :state, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :store_gateways
  end
end
