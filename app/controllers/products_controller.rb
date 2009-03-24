class ProductsController < ApplicationController
  
  def index
    options = { :page => params[:page] }
    @products = @store.products.search( params[:search], options )
#    render_products
  end
  
end
