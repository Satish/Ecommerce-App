# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  audit User, Blog, Post, Comment, Brand, Category, Product, ShippingMethod, ShippingCountry, ProductAttribute, Page, Order, Note

  before_filter :find_store, :current_cart
  before_filter :set_blog_time_zone
  append_after_filter :set_meta_attributes
  helper_method :get_url_to_back
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  private #########################################

  def set_blog_time_zone
    Time.zone = @blog.time_zone if @blog
  end

  def set_meta_attributes
    @meta_title = @store.meta_title unless @meta_title
    @meta_description = @store.meta_description unless @meta_description
    @meta_keywords = @store.meta_keywords unless @meta_keywords
  end

  def find_store
    @store = Store.first
    @currency = @store.currencies.active.first if @store
  end

  def current_cart
    @cart ||= session[:cart] ||= Cart.new
  end

  def find_order_by
    return ORDER_BY_OPTIONS[params[:sort_by]] ? ORDER_BY_OPTIONS[params[:sort_by]] : "name ASC"
  end

  def get_per_page_items(count)
    PER_PAGE_OPTIONS.include?(count.to_i) ? count : 16
  end

  def render_products
    respond_to do |format|
      format.html # products.html.erb
      format.js do
        render :update do |page|
          page.replace_html "productsBox", :partial => "products/products"
        end
      end
      format.xml { render :xml => @products.to_xml(Product::TO_XML_OPTIONS) }
    end
  end

  def parse_page_number(page)
    page.to_i == 0 ? 1 : page.to_i
  end

  def get_url_to_back(default = '/')
    request.env["HTTP_REFERER"].blank? ? default : request.env["HTTP_REFERER"]
  end

end
