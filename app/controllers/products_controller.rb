class ProductsController < ApplicationController
  
  before_filter :find_product, :only => [:show]
  
  def index
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @store.products.search( params[:search], options )
    render_products
  end
  
  def show
    
  end
  
  private ####################
  
  def find_product
    @product = @store.products.find_by_id(params[:id])
    redirect_to [Product.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product
  end
  
end
