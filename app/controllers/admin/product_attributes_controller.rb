class Admin::ProductAttributesController < Admin::BaseController
  
  before_filter :find_product_attribute, :only => [:show, :edit, :update, :destroy]
  
  def index
    options = { :page => params[:page] }
    @product_attributes = @store.product_attributes.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_attributes }
    end
  end

  def new
    @product_attribute = ProductAttribute.new
  end

  def create
    @product_attribute = ProductAttribute.new(params[:product_attribute])
    if @store.product_attributes << @product_attribute
      redirect_to_product_attributes_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_attribute }
    end
  end

  def update
    if @product_attribute.update_attributes((params[:product_attribute]))
      redirect_to_product_attributes_home
    else
      render :action => :edit
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Product Attribute '#{ @product_attribute.name }' deleted successfully"# if @product_attribute.destroy
        redirect_to_product_attributes_home
      end
      format.js do
        render :update do |page|
          #page.remove("product_attribute_#{ @product_attribute.id }")
        end
      end
    end
  end
  
  private #######################
  
  def find_product_attribute
    @product_attribute = @store.product_attributes.find_by_id(params[:id])
    redirect_to_product_attributes_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product_attribute
  end
  
  def redirect_to_product_attributes_home
    redirect_to [:admin, ProductAttribute.new] and return
  end
  
end
