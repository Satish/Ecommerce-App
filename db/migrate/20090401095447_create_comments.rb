class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :author, :author_url, :author_email
      t.text :description
      t.boolean :spam, :default => false
      t.string :state, :default => 'unapproved', :limit => 15
      t.references :commentable, :polymorphic => true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type], :name => "index_comments_on_commentable_id_and_commentable_type"
    add_index :comments, [:commentable_id, :commentable_type, :state], :name => "index_comments_on_commentable_id_and_commentable_type_state"
  end

  def self.down
    drop_table :comments
  end
end
