class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.references  :order, :shipping_method, :shipping_address
      t.string      :tracking_number
      t.decimal     :cost, :precision => 8, :scale => 2, :default => 0.0
      t.datetime    :shipped_at, :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end
