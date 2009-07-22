class ProductsController < ApplicationController
  
  before_filter :find_product, :only => [:show]

  def index
    options = { :page => parse_page_number(params[:page]), :per_page => get_per_page_items(params[:per_page]), :order => find_order_by }
    @products = @store.products.search( params[:query], options )
    render_products
  end
  
  def show; end

  def update_select_options
    product = @store.products.find_by_id(params[:id])
    sku_ids = product.attribute_values.find_all_by_value(params[:attribute_value]).collect{|av| av.sku_id }
    product_attribute = @store.product_attributes.find_by_name(params[:attribute])
    attribute_values = product.attribute_values.find_all_by_sku_id(sku_ids, :conditions => {:product_attribute_id => product_attribute.id } )
    render :partial => 'update_select_options', :locals => { :attribute_values => attribute_values }
  end

  private ####################
  
  def find_product
    @product = @store.products.find_by_permalink(params[:permalink])
    redirect_to [Product.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product
  end
  
end
