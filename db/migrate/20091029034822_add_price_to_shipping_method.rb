class AddPriceToShippingMethod < ActiveRecord::Migration
  def self.up
    add_column :shipping_methods, :price, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :shipping_methods, :price
  end
end
