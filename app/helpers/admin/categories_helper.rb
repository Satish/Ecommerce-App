module Admin::CategoriesHelper
  
  def category_options_for_select
    "<option value=''>Select Parent Category</option>" + option_groups_from_collection_for_select(@store.categories.roots.reject(&:new_record?), :category_options_for_optgroup, :title, :id, :title, @category.parent ? @category.parent.id : nil)
  end

  def add_product_view?
    params[:action] == 'add_products'
  end

end
