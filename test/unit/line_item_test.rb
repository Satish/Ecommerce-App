# == Schema Information
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  order_id   :integer(4)
#  sku_id     :integer(4)
#  quantity   :integer(4)
#  price      :decimal(8, 2)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
