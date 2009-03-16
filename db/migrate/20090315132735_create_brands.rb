class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string          :name, :permalink, :meta_title
      t.text            :description, :meta_description, :meta_keywords
      t.references      :store
      t.boolean         :status, :default => true
      t.datetime        :deleted_at
      
      t.timestamps
    end
    add_index "brands", ["store_id", "permalink"], :name => "index_brands_on_store_id_and_permalink", :uniq => true
  end

  def self.down
    drop_table :brands
  end
end
