class Admin::SkusController < Admin::BaseController
  
  before_filter :find_product
  before_filter :find_sku, :only => [:show, :edit, :update, :destroy]
  
  def index
    options = { :page => params[:page] }
    @skus = @product.skus.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skus }
    end
  end

  def new
    @sku = Sku.new
  end

  def create
    @sku = Sku.new(params[:sku])
    if @product.skus << @sku
      redirect_to_skus_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sku }
    end
  end

  def update
    if @sku.update_attributes((params[:sku]))
      redirect_to_skus_home
    else
      render :action => :edit
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Sku '#{ @sku.title }'deleted successfully"# if @sku.destroy
        redirect_to_skus_home
      end
      format.js do
        render :update do |page|
          #page.remove("sku_#{ @sku.id }")
        end
      end
    end
  end
  
  private #######################

  def find_product
    @product = @store.products.find_by_id(params[:product_id])
    redirect_to [:admin, Product.new] and return and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @product
  end
  
  def find_sku
    @sku = @product.skus.find_by_id(params[:id])
    redirect_to_skus_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @sku
  end
  
  def redirect_to_skus_home
    redirect_to [:admin, @product, Sku.new] and return
  end

end