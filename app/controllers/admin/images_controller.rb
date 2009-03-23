class Admin::ImagesController < Admin::BaseController
  
  before_filter :find_image, :only => [:destroy]
  
  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Image deleted successfully" if @image.destroy
        redirect_to_brands_home
      end
      format.js do
        render :update do |page|
          page.remove("image_#{ @image.id }") if @image.destroy
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
