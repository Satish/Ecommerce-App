# == Schema Information
#
# Table name: categories
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)
#  permalink        :string(255)
#  meta_title       :string(255)
#  description      :text
#  meta_description :text
#  meta_keywords    :text
#  store_id         :integer(4)
#  parent_id        :integer(4)
#  active           :boolean(1)      default(TRUE)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
