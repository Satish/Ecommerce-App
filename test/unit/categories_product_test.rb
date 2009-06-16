# == Schema Information
#
# Table name: categories_products
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  product_id  :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class CategoriesProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
