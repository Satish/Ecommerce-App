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
end
