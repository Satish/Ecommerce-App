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

class MailSetting < ActiveRecord::Base

  include Authentication

  attr_protected :store_id

  validates_presence_of  :mail_host, :mail_domain, :mail_port, :mail_auth_type, :smtp_username, :smtp_password, :mails_from, :order_from, :if => Proc.new{ |u| u.enable_mail_delivery }
  validates_inclusion_of :secure_connection_type, :in => SECURE_CONNECTION_TYPES, :message => "{{value}} is not included in the list"
  validates_inclusion_of :mail_auth_type,         :in => MAIL_AUTH,               :message => "{{value}} is not included in the list"
  validates_format_of    :mails_from,     :with => Authentication.email_regex,    :message => Authentication.bad_email_message, :if => Proc.new{ |u| !u.mails_from.blank? }
  validates_format_of    :order_from,     :with => Authentication.email_regex,    :message => Authentication.bad_email_message, :if => Proc.new{ |u| !u.order_from.blank? }
  validates_format_of    :mail_bcc,       :with => Authentication.email_regex,    :message => Authentication.bad_email_message, :if => Proc.new{ |u| !u.mail_bcc.blank? }
  validates_format_of    :order_bcc,      :with => Authentication.email_regex,    :message => Authentication.bad_email_message, :if => Proc.new{ |u| !u.order_bcc.blank? }


  belongs_to :store

end
