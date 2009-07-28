# == Schema Information
#
# Table name: creditcard_transactions
#
#  id               :integer(4)      not null, primary key
#  creditcard_id    :integer(4)
#  amount           :decimal(8, 2)   default(0.0)
#  transaction_id   :string(255)
#  transaction_type :string(255)
#  response_code    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class CreditcardTransaction < ActiveRecord::Base

  validates_presence_of :creditcard_id, :amount, :transaction_id, :action

  belongs_to :creditcard

end
