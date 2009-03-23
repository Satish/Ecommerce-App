module Admin::SkusHelper
  
  def get_attribute_values_list(sku)
    sku.attribute_values.collect{ |av| "<strong>#{av.product_attribute.name}</strong>:#{ av.value }" }.join(', ')
  end
  
end
