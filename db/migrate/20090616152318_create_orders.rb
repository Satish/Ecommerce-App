class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references    :user, :store
      t.string        :state, :default => "checking_out"
      t.string        :tracking_number, :payment_type, :number
      t.string        :number, :limit => 30
      t.integer       :transaction_id
      t.decimal       :total_amount, :tax_amount, :shipping_amount, :handling_amount, :total_discount, :default => 0.0, :precision => 8, :scale => 2
      t.integer       :checkout_step, :default => 1, :limit => 1
      t.datetime      :deleted_at

      t.timestamps
    end
    add_index :orders, [:created_at], :name => "index_orders_on_created_at"
    add_index :orders, [:state], :name => "index_orders_on_state"
    add_index :orders, [:user_id, :created_at, :state], :name => "index_orders_on_user_id_and_created_at_and_state"
  end

  def self.down
    drop_table :orders
  end
end
