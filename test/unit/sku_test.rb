# == Schema Information
#
# Table name: skus
#
#  id               :integer(4)      not null, primary key
#  number           :string(255)
#  quantity         :integer(4)      default(0)
#  additional_price :float           default(0.0)
#  product_id       :integer(4)
#  deleted_at       :datetime
#  active           :boolean(1)      default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class SkuTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
