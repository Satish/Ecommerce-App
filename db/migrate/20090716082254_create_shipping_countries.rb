class CreateShippingCountries < ActiveRecord::Migration
  def self.up
    create_table :shipping_countries do |t|
      t.references  :shipping_method, :store_country, :country
  
      t.timestamps
    end
    add_index :shipping_countries, [:shipping_method_id, :store_country_id], :name => 'index_shipping_countries_on_shipping_method_and_store_country'
    add_index :shipping_countries, :store_country_id
  end

  def self.down
    drop_table :shipping_countries
  end
end
