class Admin::PostsController < Admin::BaseController
  
  before_filter :find_blog
  before_filter :find_post, :only => [:show, :edit, :update, :destroy]
  
  def index
    options = {:page => params[:page]}
    @posts = params[:tag].blank? ? @blog.posts.search(params[:search], options) : @blog.posts.paginate_tagged_with(params[:tag], options)
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml{ render :xml => @posts }
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.new(params[:post])
    if @blog.posts << @post
      @post.publish! if params[:commit] == "Publish"
      respond_to do |format|
        format.html do
          flash[:message] = 'Post Created successfully.'
          redirect_to [:admin, @post] and return
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'new'}
      end
    end
  end
  
  def edit; end
  
  def update
    if @post.update_attributes(params[:post])
      respond_to do |format|
        format.html do
          flash[:message] = 'Post updated successfully.'
          redirect_to [:admin, @post] and return
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit'}
      end
    end
  end
  
  def destroy
    respond_to do |format|
      format.js # destroy.rjs
      format.html do
        flash[:message] = 'Post deleted successfully.' if @post.delete!
        redirect_to_posts_home and return
      end
    end
  end
  
  private #######################
  
  def find_post
    @post = @blog.posts.find_by_id(params[:id])
    redirect_to_posts_home and return unless @post
  end
  
  def redirect_to_posts_home
    redirect_to [:admin, Post.new] and return
  end
 
end
