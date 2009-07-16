class CreateStoreCountries < ActiveRecord::Migration
  def self.up
    create_table :store_countries do |t|
      t.references :store, :country

      t.timestamps
    end
  end

  def self.down
    drop_table :store_countries
  end
end
