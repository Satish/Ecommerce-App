# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :find_store
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  private
  
  def find_store
    @store = Store.first  
  end
  
  def find_order_by
    sort_options = {"Arrange by A-Z" => "name ASC", "Arrange by Z-A" => "name DESC", "Price (Low-High)" => "price ASC", "Price (High-Low)" => "price DESC" }
    return sort_options[params[:sort_by]] ? sort_options[params[:sort_by]] : "name ASC"
  end
  
  def get_per_page_items(count)
    [16, 40, 80, 120, 500].include?(count.to_i) ? count : 16
  end
  
  def render_products
    respond_to do |format|
      format.html # products.html.erb
      format.js do
        render :update do |page|
          page.replace_html "productsBox", :partial => "products/products"
        end
      end
      format.xml { render :xml => @products }
    end
  end
end
