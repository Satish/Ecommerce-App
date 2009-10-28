class OrderDrop < BaseDrop
  
  liquid_attributes << :state << :number << :tracking_number << :transaction_id << :total_amount << :tax_amount << :shipping_amount
  liquid_attributes << :handling_amount << :total_discount << :created_at << :shipping_address << :billing_address << :line_items << :store

  def shipping_method_name
    @source.shipment.shipping_method.name
  end

end