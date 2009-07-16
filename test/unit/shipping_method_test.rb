# == Schema Information
#
# Table name: shipping_methods
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  store_id   :integer(4)
#  status     :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ShippingMethodTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
