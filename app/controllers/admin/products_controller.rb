class Admin::ProductsController < Admin::BaseController
  
  before_filter :find_product, :only => [:show, :edit, :update, :destroy]
  before_filter :set_metas, :only => [:show]
  
  def index
    options = { :page => params[:page] }
    @products = @store.products.published.search( params[:search], options )
    render_products
  end

  def new
    @product = Product.new
    @product.images.build
  end

  def create
    @product = Product.new(params[:product])
    if @store.products << @product
      flash[:notice] = "Atleast one SKU is required for a product. Otherwise customer will not be able to add this product to his/her shopping cart.", { :timeout => 100 }
      redirect_to new_admin_product_sku_path(@product)
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

  def deleted
    options = { :page => params[:page] }
    @products = @store.products.deleted.search( params[:search], options )
    render_products
  end

  def restore
    @product = @store.products.deleted.find_by_id(params[:id])
    if @product.restore
      flash[:message] = "Product with name <em>#{ h(@product.name) }</em> restored successfully."
      redirect_back_or_default(deleted_admin_products_path)
    else
      render :edit
    end
  end

  private #######################
  
  def find_product
    @product = @store.products.find_by_id(params[:id], :include => [:brand])
    redirect_to_products_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product
  end
  
  def redirect_to_products_home
    redirect_to [:admin, Product.new] and return
  end
  
  def set_metas
    @meta_title = @product.name.titleize if @product
  end
  
end
