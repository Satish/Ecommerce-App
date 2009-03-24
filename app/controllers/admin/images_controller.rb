class Admin::ImagesController < Admin::BaseController
  
  before_filter :find_image, :only => [:destroy]
  
  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Image deleted successfully" if @image.attachable.images.count > 1 and @image.destroy
        redirect_to_images_home
      end
      format.js do
        render :update do |page|
          if @image.attachable.images.count > 1 and @image.destroy
            page.remove("image_#{ @image.id }") 
          else
            page.alert("Last Image of this #{@image.attachable.class} can't be deleted")
          end
        end
      end
    end
  end
  
  private #######################
  
  def find_image
    @image = @store.images.find_by_id(params[:id])
    redirect_to_images_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @image
  end
  
  def redirect_to_images_home
    redirect_to [:admin, Image.new] and return
  end
  
end
