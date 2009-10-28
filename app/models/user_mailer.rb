class UserMailer < ActionMailer::Base
  
  def signup_notification(user, store)
    setup_email(user, store)
    @subject    += 'Please activate your new account' 
    @body[:url] = get_activation_link(user, store)
  end
  
  def activation(user, store)
    setup_email(user, store)
    @subject    += 'Your account has been activated!'
    @body[:url] = "http://www.#{store.domain}/login"
  end

  def resend_activation(user, store =  user.store)
    setup_email(user, store)
    @subject     += 'Please activate your account'
    @body[:url]  = get_activation_link(user, store)
  end

  protected ################################

  def setup_email(user, store)
    recipients    user.email
    from          store.email
    subject       "[www.#{store.domain}]"
    sent_on       Time.now
    content_type  "text/html"
    @body[:user]= UserDrop.new(user)
    @body[:store] = StoreDrop.new(store)
  end

#  def render_message(method_name, body)
#    mail_template = body[:order].store.mail_templates.find_by_name(method_name)
#    template = Liquid::Template.parse(mail_template.body)
#    template.render('order'=> OrderDrop.new(body[:order]), 'order_status_url'=> body[:url], 'login_url' => body[:login_url] )
#    template = Liquid::Template.parse(File.read(Rails.root + "app/views/user_mailer/#{ method_name }.html.liquid"))
#    template.render('user'=> UserDrop.new(body[:user]), 'store'=> StoreDrop.new(body[:store]), 'url' => body[:url] )
#  end

  def get_activation_link(user, store)
    activate_url(:activation_code => user.activation_code, :host => "www.#{store.domain}")
  end

end