class OrderMailer < ActionMailer::Base

  def new_order(order, url, login_url)
    setup_email(order)
    subject "[#{ order.store.domain }] Your Order has been Created ##{ order.order_id }."
    body :order => order, :url => url, :login_url => login_url
  end
  
  def rejected_order(order)
    setup_email(order)
  end
  
  def accepted_order(order)
    setup_email(order)
  end
  
  def shipped_order(order)
    setup_email(order)
  end
  
  def render_message(method_name, body)
#    mail_template = body[:order].store.mail_templates.find_by_name(method_name)
#    template = Liquid::Template.parse(mail_template.body)
#    template.render('order'=> OrderDrop.new(body[:order]), 'order_status_url'=> body[:url], 'login_url' => body[:login_url] )
    template = Liquid::Template.parse(File.read(Rails.root + "/app/views/order_mailer/#{method_name}.html.liquid"))
    template.render('user'=> UserDrop.new(body[:user]), 'store'=> StoreDrop.new(body[:store]), 'url' => body[:url] )
  end

  #-------------------------- private -------------------------
  private

  def setup_email(order)
    subject "[#{ order.store.domain }] Order updates for order ID ##{ order.order_id }."    
    recipients      order.billing_address.email
    bcc             order.store.email
    from            order.store.email
    body            :order => order, :user => order.user
    content_type    "text/html"
    sent_on         Time.now
  end

end
