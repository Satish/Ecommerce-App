module ProductsHelper

  def product_path(product, options = {})
    super(product.permalink, options)
  end

end
