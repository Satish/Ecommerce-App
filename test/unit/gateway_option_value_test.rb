# == Schema Information
#
# Table name: gateway_option_values
#
#  id                :integer(4)      not null, primary key
#  value             :text
#  gateway_option_id :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class GatewayOptionValueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
