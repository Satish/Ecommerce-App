# == Schema Information
#
# Table name: stores
#
#  id                       :integer(4)      not null, primary key
#  domain                   :string(255)
#  email                    :string(255)
#  address                  :string(255)
#  display_name             :string(255)
#  toll_free_number         :string(255)
#  meta_title               :string(255)
#  google_analytics_account :string(255)
#  add_this_username        :string(255)
#  description              :text
#  disable_message          :text
#  meta_description         :text
#  meta_keywords            :text
#  status                   :boolean(1)      default(TRUE)
#  deleted_at               :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  handling_fee             :decimal(8, 2)   default(0.0)
#

require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
