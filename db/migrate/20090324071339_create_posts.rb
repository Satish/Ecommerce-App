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
    add_index :posts, [:blog_id, :permalink], :name => "index_blogs_on_blog_id_and_permalink", :uniq => true
    add_index :posts, [:blog_id, :state], :name => "index_blogs_on_blog_id_and_state"
  end

  def self.down
    drop_table :posts
  end
end
