# == Schema Information
#
# Table name: store_countries
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class StoreCountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
