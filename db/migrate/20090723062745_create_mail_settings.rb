class CreateMailSettings < ActiveRecord::Migration
  def self.up
    create_table :mail_settings do |t|
      t.string      :mail_host, :mail_domain, :default => 'localhost'
      t.integer     :mail_port, :default => 25
      t.string      :mail_auth_type, :default => MAIL_AUTH[0] 
      t.string      :smtp_username, :smtp_password
      t.string      :mails_from, :mail_bcc, :order_from, :order_bcc, :default => "test@example.com"
      t.string      :secure_connection_type, :default => SECURE_CONNECTION_TYPES[0] 
      t.boolean     :enable_mail_delivery, :default => false
      t.references  :store

      t.timestamps
    end
    Store.all.each{ |store| MailSetting.create( :store_id => store.id ) }
  end

  def self.down
    drop_table :mail_settings
  end
end
