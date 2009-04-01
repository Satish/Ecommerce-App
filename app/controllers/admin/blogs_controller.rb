class Admin::BlogsController < Admin::BaseController
  
  before_filter :find_blog

  # GET /blog
  def show
    redirect_to edit_admin_blog_path
  end

  # GET /blogs/1/edit
  def edit; end
  
  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:message] = 'Settings updated successfully.'
        format.html { redirect_to(edit_admin_blog_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
