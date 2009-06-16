class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string      :title
      t.text        :body
      t.boolean     :viewed,        :default => false
      t.integer     :noteable_id
      t.string      :noteable_type
      t.references  :user
      t.datetime    :deleted_at
      
      t.timestamps
    end
    add_index :notes, [:user_id], :name => "index_notes_on_user_id"
    add_index :notes, [:noteable_id, :noteable_type], :name => "index_notes_on_noteable_id_and_noteable_type"
  end

  def self.down
    drop_table :notes
  end
end
