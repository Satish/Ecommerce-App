class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.references  :store
      t.string      :name, :subject, :from, :cc, :bcc
      t.text        :body, :parsed_body

      t.timestamps
    end
    Store.all.each_with_index do |store, index|
      puts = "Creating email templetes for existing stores" if index.zero?
      store.email_templates.create(["signup_notification", "activation", "resend_activation", "new_order", "rejected_order", "accepted_order", "shipped_order"].collect{ |name| { :name => name, :from => store.email, :body => File.read(Rails.root + "lib/email_templates/#{ name }.html.liquid") } } )
      puts = "Email Templetes created successfully for #{ store.domain }"
    end
  end

  def self.down
    drop_table :email_templates
  end
  
end
