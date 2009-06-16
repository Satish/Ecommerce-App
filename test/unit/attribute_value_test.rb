# == Schema Information
#
# Table name: attribute_values
#
#  id                   :integer(4)      not null, primary key
#  value                :string(255)
#  sku_id               :integer(4)
#  product_attribute_id :integer(4)
#  active               :boolean(1)      default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class AttributeValueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
