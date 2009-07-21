module Admin::CategoriesHelper
  
  def category_options_for_select
    option_groups_from_collection_for_select(@store.categories.reject(&:new_record?), :category_options_for_optgroup, :title, :id, :title, @category.parent ? @category.parent.id : nil)
  end

  def add_product_view?
    params[:action] == 'add_products'
  end

end
