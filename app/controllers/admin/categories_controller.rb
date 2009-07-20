class Admin::CategoriesController < Admin::BaseController
  
  before_filter :find_category, :only => [:show, :edit, :update, :destroy, :products]
  before_filter :set_metas, :only => [:show]
  
  def index
    options = { :page => params[:page] }
    @categories = @store.categories.search( params[:search], options )
    respond_to do |format|
      format.html #index.html.erb
      format.js #index.rjs
      format.xml  { render :xml => @categories }
    end
  end

  def new
    @category = Category.new
    @category.images.build
  end

  def create
    @category = Category.new(params[:category])
    if @store.categories << @category
      redirect_to_categories_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  def update
    unless params[:product_ids]
      if @category.update_attributes((params[:category]))
        redirect_to_categories_home
      else
        render :action => :edit
      end
    else
      add_products_to_category
      redirect_to [:products, :admin, @category]
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Category '#{ @category.title }' deleted successfully" if @category.destroy
        redirect_to_categories_home
      end
      format.js do
        render :update do |page|
          #page.remove("category_#{ @category.id }")
        end
      end
    end
  end
  
  def products
    options = { :page => params[:page] }
    @products = @category.products.search( params[:search], options )
    render_products
  end
  
  private #######################
  
  def find_category
    @category = @store.categories.find_by_id(params[:id])
    redirect_to_categories_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @category
  end
  
  def redirect_to_categories_home
    redirect_to [:admin, Category.new] and return
  end
  
  def set_metas
    @meta_title = @category.title.titleize if @category
  end

  def add_products_to_category
    begin
      @category.products << @store.products.find(params[:product_ids])
    rescue
      flash[:error] = BAD_REQUEST_ERROR_MESSAGE
    end
  end

end
