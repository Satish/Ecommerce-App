class CreateStoreCountries < ActiveRecord::Migration
  def self.up
    create_table :store_countries do |t|
      t.references :store, :country

      t.timestamps
    end
    add_index :store_countries, :store_id
  end

  def self.down
    drop_table :store_countries
  end
end
