class CreateAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :attribute_values do |t|
      t.string          :value
      t.references      :sku, :product_attribute
      t.boolean         :active, :default => true

      t.timestamps
    end
    add_index "attribute_values", ["sku_id"], :name => "index_attribute_values_on_sku_id"
  end

  def self.down
    drop_table :attribute_values
  end
end
