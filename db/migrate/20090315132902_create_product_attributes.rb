class CreateProductAttributes < ActiveRecord::Migration
  def self.up
    create_table :product_attributes do |t|
      t.string        :name
      t.references    :store
      t.boolean       :status, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :product_attributes
  end
end
