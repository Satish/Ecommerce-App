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
    return [["Show 16 Per Page", 16], ["Show 40 Per Page", 40], ["Show 80 Per Page", 80], ["Show 120 Per Page", 120]]
  end
  
  def get_options_for_sort_by
    return ["Arrange by A-Z", "Arrange by Z-A", "Price (High-Low)", "Price (Low-High)"]
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
  
  private ##################

  def currency_precision
    2
  end
  
  def currency_unit
    #'$'
  end
  
  def precision_percentage
    1
  end
  
end
