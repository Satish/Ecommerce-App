class Admin::EmailTemplatesController < Admin::BaseController

  before_filter :find_email_template, :only => [:edit, :update]
  before_filter :set_metas
  
  def index
    options = { :page => params[:page] }
    @email_templates = @store.email_templates.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @email_templates }
    end
  end

  def edit; end

  def update
    if @email_template.update_attributes((params[:email_template]))
      flash[:message] = "#{ @email_template.name.titleize } email template updated successfully."
      redirect_to_email_templates_home
    else
      render :action => :edit
    end
  end
  
  private #######################
  
  def find_email_template
    @email_template = @store.email_templates.find_by_id(params[:id])
    redirect_to_email_templates_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @email_template
  end
  
  def redirect_to_email_templates_home
    redirect_to admin_email_templates_path and return
  end
  
  def set_metas
    @meta_title = @email_template.name.titleize if @email_template
  end

end
