class CategoriesController < ApplicationController
  
  before_filter :find_category, :only => [:show]
  
  def index
    options = { :page => params[:page], :per_page => 12 }
    @categories = @store.categories.search( params[:search], options )
  end
  
  def show
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @category.products.search( params[:search], options )
  end
  
  private ####################
  
  def find_category
    @category = @store.categories.find_by_id(params[:id])
    redirect_to [Category.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @category
  end

end
