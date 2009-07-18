class CreateProductAttributes < ActiveRecord::Migration
  def self.up
    create_table :product_attributes do |t|
      t.string        :name
      t.references    :store
      t.boolean       :active, :default => true
      
      t.timestamps
    end
    add_index :product_attributes, [:store_id], :name => "index_product_attributes_on_store_id", :uniq => true
  end

  def self.down
    drop_table :product_attributes
  end
end
