class AddColumnToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :auto_capture, :boolean, :default => true
    add_column :stores, :product_selection_option, :boolean, :default => true
  end

  def self.down
    remove_column :stores, :auto_capture
  end
end
