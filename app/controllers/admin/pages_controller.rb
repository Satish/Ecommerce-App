class Admin::PagesController < Admin::BaseController
  
  before_filter :find_page, :only => [:show, :edit, :update, :destroy]
  before_filter :set_metas, :only => [:show]

  def index
    options = { :page => params[:page] }
    @pages = @store.pages.search( params[:search], options )
    respond_to do |format|
      format.html #index.html.erb
      format.js #index.rjs
      format.xml{ render :xml => @pages }
    end
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    if @store.pages << @page
      flash[:message] = 'Page Created successfully.'
      redirect_to_pages_home
    else
      render :action => 'new'
    end
  end
  
  def edit; end
  
  def update
    if @page.update_attributes(params[:page])
      flash[:message] = 'Page updated successfully.'
      redirect_to_pages_home
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    respond_to do |format|
      format.js do
        render :update do |page|
          if @page.destroy
            page.remove("page_#{@page.id}")
          else
            page.alert(BAD_REQUEST_ERROR_MESSAGE)
          end
        end
      end
      format.html do
        flash[:message] = 'Page deleted successfully.' if @page.destroy
        redirect_to_pages_home
      end
    end
  end
  
  private #######################
  
   def find_page
    @page = @store.pages.find_by_id(params[:id])
    redirect_to_pages_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @page
  end
  
  def redirect_to_pages_home
    redirect_to [:admin, Page.new] and return
  end
  
  def set_metas
    @meta_title = @page.title.titleize if @page
  end
  
end
