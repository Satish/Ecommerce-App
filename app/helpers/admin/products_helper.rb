module Admin::ProductsHelper
  
  def add_image_link(name, prefix = 'product')
    link_to_function name do |page| 
      page.insert_html :after, :images, :partial => 'admin/images/form', :object => Image.new, :locals => { :prefix => prefix }
    end 
  end
  
end
