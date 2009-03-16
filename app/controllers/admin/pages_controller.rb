class Admin::PagesController < Admin::BaseController
  
  before_filter :find_page, :only => [:show, :edit, :update, :destroy]
  
  def index
    @pages = Page.search(params[:search], params[:page])
    respond_to do |format|
      format.html{}
      format.xml{ render :xml => @pages }
    end
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:message] = 'Page Created successfully.'
      redirect_to [:admin, @page] and return
    else
      render :action => 'new'
    end
  end
  
  def edit; end
  
  def update
    if @page.update_attributes(params[:page])
      flash[:message] = 'Page updated successfully.'
      redirect_to [:admin, @page] and return
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
        redirect_to_pages_home and return
      end
    end
  end
  
  private #######################
  
  def find_page
    @page = Page.find_by_id(params[:id])
    redirect_to_pages_home and return unless @page
  end
  
  def redirect_to_pages_home
    redirect_to [:admin, Page.new] and return
  end
  
end
