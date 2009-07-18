class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string      :name, :iso_name, :limit => 80
      t.string      :iso,             :limit => 2
      t.string      :iso3,            :limit => 3
      t.integer     :numcode
      t.references  :store

      t.timestamps
    end
    add_index :countries, :store_id
  end

  def self.down
    drop_table :countries
  end
end
