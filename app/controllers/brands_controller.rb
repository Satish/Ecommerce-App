class BrandsController < ApplicationController
 
  before_filter :find_brand, :only => [:show]
  
  def index
    options = { :page => params[:page], :per_page => 12 }
    @brands = @store.brands.search( params[:search], options )
  end
  
  def show
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @brand.products.search( params[:search], options )
  end
  
  private ####################
  
  def find_brand
    @brand = @store.brands.find_by_id(params[:id])
    redirect_to [Product.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @brand
  end

end
