class CreateCreditcards < ActiveRecord::Migration
  def self.up
    create_table :creditcards do |t|
      t.string        :first_name, :last_name, :cc_type, :month, :year, :number, :verification_value
      t.references    :order

      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :creditcards
  end
end
