class BrandsController < ApplicationController
 
  before_filter :find_brand, :only => [:show]
  
  def index
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]) }
    @brands = @store.brands.search( params[:search], options )
    respond_to do |format|
      format.html # brands.html.erb
      format.js do
        render :update do |page|
          page.replace_html "brandsBox", :partial => "brands"
        end
      end
      format.xml { render :xml => @brands }
    end
  end
  
  def show
    options = { :page => params[:page], :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @brand.products.search( params[:search], options )
    render_products
  end
  
  private ####################
  
  def find_brand
    @brand = @store.brands.find_by_id(params[:id])
    redirect_to [Product.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @brand
  end

end
