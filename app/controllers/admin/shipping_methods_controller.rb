class Admin::ShippingMethodsController < Admin::BaseController

  before_filter :find_shipping_method, :only => [:edit, :update, :destroy]
  
  def index
    options = { :page => params[:page] }
    @shipping_methods = @store.shipping_methods.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @shipping_methods }
    end
  end  
  
  def new
    @shipping_method = ShippingMethod.new
  end
    
  def create
    @shipping_method = ShippingMethod.new(params[:shipping_method])
    if @store.shipping_methods << @shipping_method
      respond_to do |format|
         flash[:message] = "Shipping Method has been created successfully"
        format.html {redirect_to [:admin, ShippingMethod.new] and return}
        end
    else
      render :action => "new"
    end    
  end
  
  def update
    @shipping_method.selected_shipping_countries = params[:shipping_method].delete(:selected_shipping_countries)
    if @shipping_method.update_attributes(params[:shipping_method]) 
      flash[:message] = "Shipping Method has been updated successfully"
      redirect_to [:admin, ShippingMethod.new] and return
    else
      render :action => "edit"
    end  
  end
  
  def destroy
    flash[:message] = "Shipping Method has been deleted successfully" if @shipping_method.destroy
    redirect_to [:admin, ShippingMethod.new] and return
  end 
  
  private ###################################
  
  def find_shipping_method
    @shipping_method = @store.shipping_methods.find_by_id(params[:id]) 
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to [:admin, ShippingMethod.new] and return unless @shipping_method
  end  

end
