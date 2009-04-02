class PostsController < ApplicationController

  layout "blog", :except => [:feed]
  before_filter :find_blog
  before_filter :find_post, :only => [:show]
#  after_filter :set_meta_atttributes
  
  # GET /posts
  # GET /posts.xml
  def index
    options = {:page => params[:page] || 1, :per_page => 2}
    @posts = (params[:tag].blank? ? @blog.posts.published.search(params[:search], options) : @blog.posts.published.paginate_tagged_with(params[:tag], options))
    respond_to do |format|
      format.html{}
      format.xml{ render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @meta_title = @post.title
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def feed
    @posts = Post.all
    respond_to do |format|
      format.rss  { render :rss => @posts }
    end
    
  end

  private ###########################
  
  def find_blog
    @blog = @store.blog
  end

  def find_post
    @post = @blog.posts.published.find_by_date_and_permalink(*([:year, :month, :day, :permalink].collect {|x| params[x]} << {:include => [:comments]}))
    redirect_to root_path and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @post
  end

end
