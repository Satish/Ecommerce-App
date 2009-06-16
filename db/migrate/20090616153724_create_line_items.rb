class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.references    :order, :sku
      t.integer       :quantity
      t.decimal       :price, :precision => 8, :scale => 2
      t.datetime      :deleted_at

      t.timestamps
    end
  
    add_index :line_items, [:order_id], :name => "index_line_items_on_order_id"
    add_index :line_items, [:sku_id], :name => "index_line_items_on_sku_id"
  end

  def self.down
    drop_table :line_items
  end
end
