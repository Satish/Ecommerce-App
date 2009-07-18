class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string      :title, :permalink
      t.references  :store 
      t.text        :description
      t.boolean     :active, :default => true

      t.timestamps
    end
    add_index :pages, [:store_id, :permalink], :name => "index_pages_on_store_id_and_permalink", :uniq => true
  end

  def self.down
    drop_table :pages
  end
end
