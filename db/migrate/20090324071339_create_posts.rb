class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :permalink, :cached_tag_list
      t.text :description
      t.references :user, :blog
      t.boolean :active, :comments_allowed, :default => true
      t.string :state, :default => 'draft'
      t.datetime :published_at, :deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
