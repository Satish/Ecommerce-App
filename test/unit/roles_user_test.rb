# == Schema Information
#
# Table name: roles_users
#
#  id         :integer(4)      not null, primary key
#  role_id    :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class RolesUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
