# == Schema Information
#
# Table name: gateway_options
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  store_gateway_id :integer(4)
#  description      :text
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class GatewayOptionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
