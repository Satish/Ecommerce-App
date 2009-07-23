# == Schema Information
#
# Table name: store_gateways
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  gateway_id :integer(4)
#  state      :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class StoreGatewayTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
