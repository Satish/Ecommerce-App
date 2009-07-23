# == Schema Information
#
# Table name: currencies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  country    :string(255)
#  format     :string(255)
#  symbol     :string(10)
#  delimiter  :string(255)     default("."), not null
#  separator  :string(255)     default(","), not null
#  rate       :decimal(10, 8)
#  precision  :integer(4)      default(2), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
