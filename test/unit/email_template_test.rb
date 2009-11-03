# == Schema Information
#
# Table name: email_templates
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  name       :string(255)
#  subject    :string(255)
#  from       :string(255)
#  cc         :string(255)
#  bcc        :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
