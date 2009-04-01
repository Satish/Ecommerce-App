class CategoriesController < ApplicationController
  
  before_filter :find_category, :only => [:show]
  
  def index
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]) }
    @categories = @store.categories.search( params[:search], options )
    respond_to do |format|
      format.html # categories.html.erb
      format.js do
        render :update do |page|
          page.replace_html "categoriesBox", :partial => "categories"
        end
      end
      format.xml { render :xml => @categories }
    end
  end
  
  def show
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @category.products.search( params[:search], options )
    render_products
  end
  
  private ####################
  
  def find_category
    @category = @store.categories.find_by_id(params[:id])
    redirect_to [Category.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @category
  end

end
