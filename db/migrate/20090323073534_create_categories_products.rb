class CreateCategoriesProducts < ActiveRecord::Migration
  def self.up
    create_table :categories_products do |t|
      t.references :category, :product
      t.boolean :active, :default => true
      
      t.timestamps
    end
    add_index :categories_products, :product_id
    add_index :categories_products, :category_id
  end

  def self.down
    drop_table :categories_products
  end
end
