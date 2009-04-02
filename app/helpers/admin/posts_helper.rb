module Admin::PostsHelper
  
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
