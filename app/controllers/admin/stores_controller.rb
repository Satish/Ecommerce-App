class Admin::StoresController < Admin::BaseController
  
  def show; end
  
  def edit; end

  def update
    if @store.update_attributes(params[:store])
      flash[:message] = "General Settings updated successfully"
      redirect_to [:admin, Store.new]      
    else
      render :action => :edit
    end
  end

end
