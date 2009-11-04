class OrderMailer < ActionMailer::Base

  def new_order(order)
    setup_email(order, order.store, "Your Order has been Created ##{ order.number }.")
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

  #-------------------------- private -------------------------
  private

  def setup_email(order, store, default_subject = "[#{ store.domain }] Order updates for Order# #{ order.number }.")
    email_template(store)
    @content_type = "text/html"
    @sent_on      = Time.now
    @recipients   = order.billing_address.email
    @bcc          = store.email
    @from         = @email_template.from
    @cc           = @email_template.cc
    @bcc          = @email_template.bcc
    @subject      = @email_template.subject.blank? ? "[#{ order.store.domain }] #{ default_subject }" : @email_template.render_subject({ :order => OrderDrop.new(order), :store => StoreDrop.new(store)}.stringify_keys!)
    @body         = @email_template.render({
                                            :user              => UserDrop.new(order.user),
                                            :order             => OrderDrop.new(order),
                                            :store             => StoreDrop.new(store),
                                            :line_items        => order.line_items.collect(&:to_liquid),
                                            :billing_address   => AddressDrop.new(order.billing_address),
                                            :shipping_address  => AddressDrop.new(order.shipping_address),
                                            :order_status_url  => "http://#{ store.domain }/orders/status",#status_orders_url(:host => store.domain),
                                            :login_url         => login_url(:host => store.domain) }.stringify_keys!)

  end

  def email_template(store)
    @email_template ||= store.email_templates.find_by_name(template)
  end

end
