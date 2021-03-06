# == Schema Information
#
# Table name: blogs
#
#  id                 :integer(4)      not null, primary key
#  title              :string(50)      default("My Blog")
#  sub_title          :string(50)      default("")
#  feeds_description  :string(20)
#  store_id           :integer(4)
#  email              :string(255)
#  time_zone          :string(255)
#  akismet_key        :string(255)
#  akismet_url        :string(255)
#  language           :string(255)
#  meta_title         :string(255)
#  description        :text
#  meta_description   :text
#  meta_keywords      :text
#  disable_message    :text
#  comment_moderation :boolean(1)      default(TRUE)
#  active             :boolean(1)      default(TRUE)
#  posts_per_page     :integer(4)      default(5)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
