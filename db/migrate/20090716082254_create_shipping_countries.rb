class CreateShippingCountries < ActiveRecord::Migration
  def self.up
    create_table :shipping_countries do |t|
      t.references  :shipping_method, :country
  
      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_countries
  end
end
