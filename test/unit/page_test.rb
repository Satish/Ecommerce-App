# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  permalink   :string(255)
#  description :text
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#  store_id    :integer(4)
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
