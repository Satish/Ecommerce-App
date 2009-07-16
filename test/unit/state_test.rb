# == Schema Information
#
# Table name: states
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbr       :string(2)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class StateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
