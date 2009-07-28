class CreateCreditcardTransactions < ActiveRecord::Migration
  def self.up
    create_table :creditcard_transactions do |t|
      t.references    :creditcard
      t.decimal       :amount, :precision => 8, :scale => 2, :default => 0.0
      t.string        :transaction_id, :action, :response_code

      t.timestamps
    end
  end

  def self.down
    drop_table :creditcard_transactions
  end
end
