class CreateSkus < ActiveRecord::Migration
  def self.up
    create_table :skus do |t|
      t.string          :number
      t.integer         :quantity, :default => 0
      t.float           :additional_price, :precision => 2, :default => 0.0
      t.references      :product
      t.datetime        :deleted_at
      t.boolean         :active, :default => true
      
      t.timestamps
    end
    add_index "skus", ["product_id", "number"], :name => "index_skus_on_product_id_and_number", :uniq => true
  end

  def self.down
    drop_table :skus
  end
end
