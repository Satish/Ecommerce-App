class Admin::BaseController < ApplicationController
    
  layout 'admin'
  before_filter :login_required
  before_filter :set_default_metas
  uses_tiny_mce(:options => AppConfig.advanced_mce_options, :only => [:new, :edit, :create, :update])
  
  def render_products
    respond_to do |format|
      format.html # products.html.erb
#      format.js { render :action => '/admin/products/products' }
      format.js do
        render :update do |page|
          page.replace "products", :partial => "admin/products/products"
        end
      end
      format.xml { render :xml => @products }
    end
  end
  
  def set_default_metas
    @meta_title = "#{@store.display_name} - #{params[:controller].split('/').last.titleize}"
  end
  
end
