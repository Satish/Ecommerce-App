class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string      :product_id, :name, :permalink, :material, :availability, :ships_in, :meta_title
      t.text        :description, :care_instruction, :meta_description, :meta_keywords
      t.references  :brand, :store
      t.float       :price, :discount, :handling_fee, :precision => 2, :default => 0.00
      t.boolean     :active, :dependent, :default => false
      t.datetime:deleted_at

      t.timestamps
    end
    add_index "products", ["product_id", "store_id"], :name => "index_products_on_product_id_and_store_id", :uniq => true
  end

  def self.down
    drop_table :products
  end
end
