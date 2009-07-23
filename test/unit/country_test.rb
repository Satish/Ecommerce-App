# == Schema Information
#
# Table name: countries
#
#  id         :integer(4)      not null, primary key
#  name       :string(80)
#  iso_name   :string(80)
#  iso        :string(2)
#  iso3       :string(3)
#  numcode    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  store_id   :integer(4)
#

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
