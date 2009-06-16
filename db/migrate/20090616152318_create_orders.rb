class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references    :user, :store, :shipping_address, :billing_address
      t.string        :status, :default => "pending"
      t.string        :tracking_number, :payment_type
      t.integer       :transaction_id, :order_id
      t.decimal       :total_amount, :tax_amount, :shipping_amount, :handling_amount, :total_discount, :default => 0.0, :precision => 8, :scale => 2
      t.datetime      :deleted_at

      t.timestamps
    end
    add_index :orders, [:created_at], :name => "index_orders_on_created_at"
    add_index :orders, [:status], :name => "index_orders_on_status"
    add_index :orders, [:user_id, :created_at, :status], :name => "index_orders_on_user_id_and_created_at_and_status"
  end

  def self.down
    drop_table :orders
  end
end
