# == Schema Information
#
# Table name: notes
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  body          :text
#  viewed        :boolean(1)
#  noteable_id   :integer(4)
#  noteable_type :string(255)
#  user_id       :integer(4)
#  deleted_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
