class AddAuditsTable < ActiveRecord::Migration
  def self.up
    create_table :audits, :force => true do |t|
      t.references    :auditable, :polymorphic => true
      t.references    :user     , :polymorphic => true
      t.string        :username, :action
      t.text          :changes
      t.integer       :version, :default => 0

      t.timestamps
    end
    
    add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audits, [:user_id, :user_type], :name => 'user_index'
    add_index :audits, :created_at  
  end

  def self.down
    drop_table :audits
  end
end
