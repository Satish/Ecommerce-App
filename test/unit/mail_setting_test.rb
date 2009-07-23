# == Schema Information
#
# Table name: mail_settings
#
#  id                     :integer(4)      not null, primary key
#  mail_host              :string(255)     default("localhost")
#  mail_domain            :string(255)     default("localhost")
#  mail_port              :integer(4)      default(25)
#  mail_auth_type         :string(255)     default("none")
#  smtp_username          :string(255)
#  smtp_password          :string(255)
#  mails_from             :string(255)     default("test@example.com")
#  mail_bcc               :string(255)     default("test@example.com")
#  order_from             :string(255)     default("test@example.com")
#  order_bcc              :string(255)     default("test@example.com")
#  secure_connection_type :string(255)     default("None")
#  enable_mail_delivery   :boolean(1)
#  store_id               :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'test_helper'

class MailSettingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
