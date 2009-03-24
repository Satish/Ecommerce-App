class Admin::ProductsController < Admin::BaseController
  
  before_filter :find_product, :only => [:show, :edit, :update, :destroy]
  before_filter :set_metas, :only => [:show]
  
  def index
    options = { :page => params[:page] }
    @products = @store.products.search( params[:search], options )
    render_products
  end

  def new
    @product = Product.new
    @product.images.build
  end

  def create
    @product = Product.new(params[:product])
    if @store.products << @product
      redirect_to_products_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  def update
    if @product.update_attributes((params[:product]))
      redirect_to_products_home
    else
      render :action => :edit
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Product '#{ @product.name }' deleted successfully" if @product.destroy
        redirect_to_products_home
      end
      format.js do
        render :update do |page|
          #page.remove("product_#{ @product.id }")
        end
      end
    end
  end
  
  private #######################
  
  def find_product
    @product = @store.products.find_by_id(params[:id])
    redirect_to_products_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product
  end
  
  def redirect_to_products_home
    redirect_to [:admin, Product.new] and return
  end
  
  def set_metas
    @meta_title = @product.name.titleize if @product
  end
  
end
