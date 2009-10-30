module Admin::OrdersHelper
  
  def get_css_class_for_order_links(params_status, status)
    params_status = (params_status and Order.aasm_states.collect(&:name).include?(params_status.downcase.to_sym)) ? params_status.downcase : ''
    return params_status == status ? 'selected' : ''
  end

  def line_items_detail(order)
    html =''
    order.line_items.each do |line_item|
      if line_item.sku
        html << "<div>#{ link_to h(line_item.sku.display_name), [:admin, line_item.sku.product] }</div>"
        html << "<div>#{ get_attribute_values(line_item.sku) }</div>"
      else
        
      end
    end
    html
  end

  def options_for_order_state_select
    Order.aasm_states_for_select
  end

  def order_prices_hash
    hash = ActiveSupport::OrderedHash.new
    hash[:sub_total] = @order.cost_of_products
    hash[:shipping_amount] = @order.shipping_amount
    hash[:handling_amount] =  @order.handling_amount
    hash[:tax_amount] =  @order.tax_amount
    hash[:discount] =  @order.total_discount
    hash[:total_amount] =  @order.total_amount
    hash
  end

  def orders_status_links
    html = ''
    {"All" => nil, "In Complete" => "checking_out", "Pending" => "pending", "Approved/Processing" => "processing", "Rejected"  => "rejected", "On Hold" => 'on_hold', "Shipped" => 'shipped' }.each do |key, status|
      html << (link_to key, admin_orders_path(:status => status), :class => "subLink #{ get_css_class_for_order_links(params[:status], status)}")
    end
    html
  end
end
