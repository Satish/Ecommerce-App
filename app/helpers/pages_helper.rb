module PagesHelper
  
  def page_path(page, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    path = '/pages/' + page.url + suffix
  end
  
end
