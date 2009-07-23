# == Schema Information
#
# Table name: gateways
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  state       :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class GatewayTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
