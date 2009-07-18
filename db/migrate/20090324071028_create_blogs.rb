class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string          :title, :limit => 50, :default => 'My Blog'
      t.string          :sub_title, :limit => 50, :default => ''
      t.string          :feeds_description, :limit => 20
      t.references      :store
      t.string          :email, :time_zone, :akismet_key, :akismet_url, :language, :meta_title
      t.text            :description, :meta_description, :meta_keywords, :disable_message
      t.boolean         :comment_moderation, :active, :default => true
      t.integer         :posts_per_page, :default => 5
      
      t.timestamps
    end
    add_index :blogs, :store_id, :uniq => true
  end

  def self.down
    drop_table :blogs
  end
end
