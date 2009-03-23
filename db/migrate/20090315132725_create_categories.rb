class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string      :title, :permalink, :meta_title
      t.text        :description, :meta_description, :meta_keywords
      t.references  :store, :parent
      t.boolean     :active, :default => true
      t.datetime    :deleted_at
      
      t.timestamps
    end
    add_index "categories", ["store_id", "permalink"], :name => "index_categories_on_store_id_and_permalink", :uniq => true
  end

  def self.down
    drop_table :categories
  end
end
