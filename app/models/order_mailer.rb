class OrderMailer < ActionMailer::Base

  def new_order(order)
    setup_email(order, order.store)
    subject  "[#{ order.store.domain }] Your Order has been Created ##{ order.number }."
  end

  def rejected_order(order)
    setup_email(order, order.store)
  end

  def accepted_order(order)
    setup_email(order, order.store)
  end

  def shipped_order(order)
    setup_email(order, order.store)
  end

#  def render_message(method_name, body)
#    mail_template = body[:order].store.mail_templates.find_by_name(method_name)
#    template = Liquid::Template.parse(mail_template.body)
#    template.render('order'=> OrderDrop.new(body[:order]), 'order_status_url'=> body[:url], 'login_url' => body[:login_url] )
#    template = Liquid::Template.parse(File.read(Rails.root + "/app/views/order_mailer/#{method_name}.html.liquid"))
#    template.render('user'=> UserDrop.new(body[:user]), 'store'=> StoreDrop.new(body[:store]), 'url' => body[:url] )
#  end

  #-------------------------- private -------------------------
  private

  def setup_email(order, store)
    @subject      = "[#{ store.domain }] Order updates for order ID ##{ order.number }."
    @recipients   = order.billing_address.email
    @bcc          = store.email
    @from         = store.email
    @body         = {:user              => UserDrop.new(order.user),
                    :order             => OrderDrop.new(order),
                    :store             => StoreDrop.new(store),
                    :line_items        => order.line_items,
                    :billing_address   => AddressDrop.new(order.billing_address),
                    :shipping_address  => AddressDrop.new(order.shipping_address),
                    :order_status_url  => "http://#{ store.domain }/orders/status",#status_orders_url(:host => store.domain),
                    :login_url         => login_url(:host => store.domain) }

    @content_type  = "text/html"
    @sent_on       = Time.now
  end

end
