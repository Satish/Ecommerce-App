# == Schema Information
#
# Table name: orders
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  store_id            :integer(4)
#  shipping_address_id :integer(4)
#  billing_address_id  :integer(4)
#  status              :string(255)     default("pending")
#  tracking_number     :string(255)
#  payment_type        :string(255)
#  transaction_id      :integer(4)
#  order_id            :integer(4)
#  total_amount        :decimal(8, 2)   default(0.0)
#  tax_amount          :decimal(8, 2)   default(0.0)
#  shipping_amount     :decimal(8, 2)   default(0.0)
#  handling_amount     :decimal(8, 2)   default(0.0)
#  total_discount      :decimal(8, 2)   default(0.0)
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
