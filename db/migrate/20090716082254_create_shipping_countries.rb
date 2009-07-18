class CreateShippingCountries < ActiveRecord::Migration
  def self.up
    create_table :shipping_countries do |t|
      t.references  :shipping_method, :country
  
      t.timestamps
    end
    add_index :shipping_methods, [:shipping_method_id, :country_id]
    add_index :shipping_methods, :country_id
  end

  def self.down
    drop_table :shipping_countries
  end
end
