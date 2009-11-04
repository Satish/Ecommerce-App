class Cart
  
  # cart is a hash with the following keys
  # id, price, qty, item_id and item_type
  
  def initialize
    @cart_items = []
    @errors = []
  end

  def add_item(item, qty = 1)
    @errors << "Quantity must be greater than zero" if qty < 1
    @errors << "We are unable to add out of stock product to your cart." if item.is_out_of_stock?
    if @errors.empty?
      if current_item = find_by_item_id_and_item_type(item.id, item.class.to_s)
        current_item[:qty] = get_quantity(current_item[:qty] + qty, item)
      else
        @cart_items << { :id => Time.now.to_i, :qty => get_quantity(qty, item), :price => item.our_price, :item_id => item.id, :item_type => item.class.to_s }
      end
    end
  end

  def remove_item(id, qty = 0)
    if current_item = find_by_id(id)
      if qty.zero?
        @cart_items.delete( current_item )
      else
        current_item[:qty] = get_quantity(qty, current_item[:item_type].constantize.find_by_id(current_item[:item_id]))
      end
    end
  end

  alias_method :update_item, :remove_item

  def get_quantity(required_items, item)
    remaining_quantity = item.quantity
    if required_items > remaining_quantity
      @errors << "The quantity for '#{ item.display_name }' in your cart has been adjusted to meet the available quantity(#{ remaining_quantity }) we currently have in stock."
      return remaining_quantity
    else
      return required_items
    end
  end

  def cart_items
    @cart_items
  end

  def errors
    @errors
  end

  def find_by_item_id_and_item_type(item_id, item_type)
    @cart_items.find{ |item| item[:item_id] == item_id && item[:item_type] == item_type }
  end

  def find_by_id(id)
    @cart_items.find{ |item| item[:id] == id }
  end

  def empty_cart
    @cart_items = []
  end

  def empty?
    cart_items.empty?
  end

  def total_price
    @cart_items.sum { |item| item[:price] * item[:qty] }
  end

  def perform_inventory_check
    cart_items.each do |cart_item|
      if item = cart_item[:item_type].constantize.find_by_id(cart_item[:item_id])
        cart_item[:qty] = get_quantity(cart_item[:qty], item)
      else
        @cart_items.delete( cart_item )
      end
    end
  end

#  def handling_fee
#    handling = 0.00
#    @cart_items.each do |item|
#      sku = Sku.find_by_id(item[:item_id]) if item[:item_type] == "Sku"
#      handling += sku.product.handling_fee * item[:count] if sku
#    end
#    handling
#  end
#  
#  def items_quantity
#    @cart_items.collect { |item| item[:count] if item[:item_type] == 'Sku'}.compact.sum
#  end
#  
#  def shipping_tax(store, country='', state='')
#    tax = 0.00
#    store.tax_options.active.each do |to|
#      tax = self.total_price * (to.tax_percent/100) and break if to.country == country and to.state == state
#    end
#    return tax
#  end
  
end