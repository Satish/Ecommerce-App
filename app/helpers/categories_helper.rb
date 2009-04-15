module CategoriesHelper

  def category_path(category, options = {})
    super(category.permalink, options)
  end

end
