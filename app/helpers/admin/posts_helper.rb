module Admin::PostsHelper
  
#  def post_path(post, options = {})
#    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
#    path = post.url + suffix
#  end
  
#  def render_tags1(post)
#    return '&nbsp' if post.cached_tag_list.blank?
#    html = ""
#    post.tag_list.each do |tag_name|
#      html << (link_to h(tag_name), posts_path(:tag=> tag_name ))
#      html << ', ' unless tag_name == post.tag_list.last
#    end
#    return html
#  end
#  
  def render_tags(post)
    return '&nbsp' if post.cached_tag_list.blank?
    html = ""
    post.tag_list.each do |tag_name|
      html << (link_to tag_name, admin_posts_path(:tag=> tag_name ))
      html << ', ' unless tag_name == post.tag_list.last
    end
    return html
  end
 
end
