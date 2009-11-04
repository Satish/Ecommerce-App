# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def number_to_currency(number, options = {})
    default_options = { :unit => currency_unit, :precision => currency_precision }
    options = default_options.merge(options)
    super
  end
  
  def number_to_percentage(number, options = {})
    default_options = { :precision => precision_percentage }
    options = default_options.merge(options)
    super
  end
  
  def products_section(*args, &block)
    unless ActionView::Base.respond_to? :erb_variable
      concat render_form
      yield
      concat render_form
    else
      content = render_form + capture(&block) + render_form
      concat(content, block.binding)
    end
  end
  
  def render_form
    render :partial => "shared/filter_options_form"
  end
  
  def sidebar_navigation_section(title, &block)
   concat "<div class = 'navSection'>"
   concat "<h1 class = 'navSectionTitle'> #{ title } </h1>"
   concat "<ul class = 'navSectionDesc'>"
    yield
   concat "</ul>"
   concat "</div>"
  end

  def get_options_for_per_page
 #   return {"Show 16 Per Page"=> 16, "Show 40 Per Page"=> 40, "Show 80 Per Page" => 80, "Show 120 Per Page" => 120}
    return [["Show 16 Per Page", 16], ["Show 40 Per Page", 40], ["Show 80 Per Page", 80], ["Show 120 Per Page", 120]]
  end
  
  def get_options_for_sort_by
    return  ORDER_BY_OPTIONS.keys
  end
  
  def get_options_for_jump_to(total_pages)
   (1..total_pages).to_a
  end
  
  def get_css_class(controller)
    'inactive'
  end
  
  def formatted_date(object)
    object.created_at.strftime("%d/%m/%Y")
  end

  def get_url_to_continue_shopping(default = products_path)
    request.env["HTTP_REFERER"].blank? || request.env["HTTP_REFERER"] == cart_url ? default : request.env["HTTP_REFERER"]
  end

  def get_attribute_values(sku)
    attribute_values = []
    sku.attribute_values.each{ |av| attribute_values << "#{ h av.product_attribute.name }: #{ h av.value }" }
    attribute_values.join(', ').size > 0 ? attribute_values.join(', ') : 'N/A'
  end

  def get_country_option(country)
    case country
    when "United States"
      return 'US'
    when "United Kingdom"
      'UK'
    else
      country
    end
  end

  def get_address_state_dom_id(address)
    address.type.to_s.underscore + '_state_block'
  end

  def sanitize_html(html)
    options = { :tags => %w(a href, b, br, i, p, strong, em, table, tr, td, tbody, th, ul, ol, li, img src, img, h1, h2, h3, h4), :attributes => %w(id class style) }
    sanitize(html, options)
  end

  def favicon_tag
    tag( :link,
         :rel   => "shortcut icon",
         :title => h(@store.display_name),
         :href  => @store.favicon_icon ? @store.favicon_icon.public_filename : @store.logo ? @store.logo.public_filename(:favicon) : nil
        )
  end

  def label(object_name, method, text = nil, options = {})
    object = options[:object]
    text = "#{ text ? text : method.to_s.humanize }<em title='required' style = 'color:red;margin-left:2px;'>*</em>" if object && object.class.required_attributes.include?(method.to_sym)
    super
  end

  def text_field(object_name, method, options = {})
    super + get_hint(options)
  end

  def select(object, method, choices, options = {}, html_options = {})
    super + get_hint(options)
  end

  def check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
    super + get_hint(options)
  end


  private ##################

  def get_hint(options)
    hint = sanitize(options.delete(:hint))
    hint ? "<div><em class = 'hint'>#{ hint }</em></div>" : ""
  end

  def currency_precision
    @currency.precision rescue 2
  end
  
  def currency_unit
    @currency.symbol rescue '$'
  end
  
  def precision_percentage
    1
  end
  
  def main_image(source, thumbnail)
    source.main_image ? image_tag(source.main_image.public_filename(thumbnail)) : image_tag("#{ thumbnail }.png", :size => Image::THUMBNAILS[thumbnail])
  end

end
