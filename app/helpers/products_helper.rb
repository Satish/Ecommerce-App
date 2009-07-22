module ProductsHelper

  def product_path(product, options = {})
    super(product.permalink, options)
  end

  def options_for_attribute_value_select(product_attribute)
    options_for_select([["Select #{ h(product_attribute.name.capitalize) }", '']] + product_attribute.attribute_values.collect{ |av| [av.value, av.value] }.uniq)
  end

  def html_options_for_attribute_value_select(product, product_attributes, index)
    options = { :class => "productOptionSelectBox", :id => "#{ product_attributes[index].name }_options" }
    options.merge!( :onchange => remote_function(:update => "#{ product_attributes[index + 1].name }_options", :url => update_select_options_path(:id => product.id), :with => "'attribute=' + '#{ product_attributes[index+1].name }' +'&attribute_value=' + $(this).attr('value')" ) ) if product_attributes[index + 1]
    options
  end

  def get_onclick_events
    "return is_selected( #{ @store.product_selection_option?('radio_buttons') ? '[\'#item_id\']' : get_options_dom_ids });"
  end

  def get_options_dom_ids
    "[#{ @store.product_attributes.collect{ |product_attribute| '\'#' + product_attribute.name + '_options\''}.join(',') }]"
  end

end