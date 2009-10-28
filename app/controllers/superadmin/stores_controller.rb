class Superadmin::StoresController < ApplicationController

  skip_filter :find_store, :current_cart, :set_blog_time_zone, :set_meta_attributes
  before_filter :authenticate
  before_filter :store, :except => [:index, :new, :create]
  before_filter :set_metas

  def index
    @stores = Store.search(params[:search], :page => params[:page], :per_page => 10, :include => [:logo])

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @stores }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store }
    end
  end

  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store }
    end
  end

  def edit; end

  def create
    @store = Store.new(params[:store])

    respond_to do |format|
      if @store.save
        flash[:message] = "Store has been created successfully"
        format.html { redirect_to_superadmin_stores_path }
        format.xml  { render :xml => @store, :status => :created, :location => @store }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @store.update_attributes(params[:store])
        flash[:message] = "Store has been updated successfully"
        format.html { redirect_to_superadmin_stores_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @store = Store.find(params[:id])
    flash[:message] = "Store has been deleted successfully"# if @store.destroy

    respond_to do |format|
      format.html { redirect_to_superadmin_stores_path }
      format.xml  { head :ok }
    end
  end

  private ##############################

  def redirect_to_superadmin_stores_path
    redirect_to superadmin_stores_path() and return
  end

  def store
    @store = Store.find_by_id(params[:id])
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to superadmin_store_path and return unless @store
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == SUPERADMIN_NAME && password == SUPERADMIN_PASSWORD
    end
  end
  
  def set_metas
    @meta_title = "SuperAdmin | Stores" + (@store ? " | #{ @store.display_name }" : '')
  end

end
