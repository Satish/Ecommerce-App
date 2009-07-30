# == Schema Information
#
# Table name: creditcard_transactions
#
#  id             :integer(4)      not null, primary key
#  creditcard_id  :integer(4)
#  amount         :decimal(8, 2)   default(0.0)
#  transaction_id :string(255)
#  action         :string(255)
#  response_code  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class CreditcardTransactionsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
