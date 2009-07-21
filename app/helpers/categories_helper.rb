module CategoriesHelper

  def category_path(category, options = {})
    super(category.permalink, options)
  end

  def product
    @product ||= @store.products.find_by_id(params[:product_id])
  end

end
