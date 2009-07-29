class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.string :name
      t.text :description
      t.boolean :state, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :gateways
  end
end
