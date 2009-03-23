class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :size, :height
      t.string :content_type, :filename, :thumbnail, :type
      t.references :attachable, :polymorphic => true
      t.references :store, :parent

      t.timestamps
    end
    add_index(:images,[:attachable_id, :attachable_type, :type], :name => 'by_type_and_all_attachable')
  end

  def self.down
    drop_table :images
  end
end
