module BrandsHelper

  def brand_path(brand, options = {})
    super(brand.permalink, options)
  end

end
