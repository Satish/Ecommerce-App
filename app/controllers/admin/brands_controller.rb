class Admin::BrandsController < Admin::BaseController
  
  before_filter :find_brand, :only => [:show, :edit, :update, :destroy, :products]
  
  def index
    options = { :page => params[:page] }
    @brands = @store.brands.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @brands }
    end
  end

  def new
    @brand = Brand.new
    #@brand.images.build
  end

  def create
    @brand = Brand.new(params[:brand])
    if @store.brands << @brand
      redirect_to_brands_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  def update
    if @brand.update_attributes((params[:brand]))
      redirect_to_brands_home
    else
      render :action => :edit
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Brand '#{ @brand.title }'deleted successfully"# if @brand.destroy
        redirect_to_brands_home
      end
      format.js do
        render :update do |page|
          #page.remove("brand_#{ @brand.id }")
        end
      end
    end
  end
  
  def products
    options = { :page => params[:page] }
    @products = @brand.products.search( params[:search], options )
    render_products
  end
  
  private #######################
  
  def find_brand
    @brand = @store.brands.find_by_id(params[:id])
    redirect_to_brands_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @brand
  end
  
  def redirect_to_brands_home
    redirect_to [:admin, Brand.new] and return
  end
  
end
