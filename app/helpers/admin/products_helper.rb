module Admin::ProductsHelper
  
  def add_image_link(name)
    link_to_function name do |page| 
      page.insert_html :after, :images, :partial => 'image', :object => Image.new
    end 
  end
  
end
