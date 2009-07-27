# == Schema Information
#
# Table name: shipments
#
#  id                  :integer(4)      not null, primary key
#  order_id            :integer(4)
#  shipping_method_id  :integer(4)
#  shipping_address_id :integer(4)
#  tracking_number     :string(255)
#  cost                :decimal(8, 2)   default(0.0)
#  shipped_at          :datetime
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
