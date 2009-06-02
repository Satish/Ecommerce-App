class CommentsController < ApplicationController

  before_filter :find_blog
  before_filter :find_post

  def create
    @comment = @post.comments.new(params[:comment])
  end

  private ###########################

  def find_blog
    @blog = @store.blog
  end

  def find_post
    @post = @blog.posts.published.find_by_id(params[:post_id])
    unless @post
      render :update do |page|
        page.alert(BAD_REQUEST_ERROR_MESSAGE)
      end
    end
  end

end
