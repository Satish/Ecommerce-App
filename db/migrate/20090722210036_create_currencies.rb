class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name, :country, :format
      t.string :symbol, :limit => 10
      t.string :delimiter, :null => false, :default => '.'
      t.string :separator, :null => false, :default => ','
      t.decimal :rate, :precision => 10, :scale => 8
      t.integer :precision, :null => false, :default => 2
      t.references :store
      t.string :state, :limit => 10, :default => 'inactive'

      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
