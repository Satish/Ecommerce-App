class PostsController < ApplicationController

  layout "blog", :except => [:feed]
  before_filter :find_blog
  before_filter :find_post, :only => [:show]
  
  # GET /posts
  # GET /posts.xml
  def index
    @meta_title = @blog.title
    
    options = {:page => parse_page_number(params[:page]), :per_page => 2}
    @posts = (params[:tag].blank? ? @blog.posts.published.search(params[:query], options) : @blog.posts.published.paginate_tagged_with(params[:tag], options))
    respond_to do |format|
      format.html{}
      format.xml{ render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @meta_title = @post.title
    @comment = @post.comments.new
    
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

  def archives
    @meta_title = "#{ @blog.title } | Archives"

    @posts = Post.published
    @post_months = @posts.group_by(&:published_month)
  end

  private ###########################

  def find_blog
    @blog = @store.blog
  end

  def find_post
#    @post = @blog.posts.published.find_by_date_and_permalink(*([:year, :month, :day, :permalink].collect {|x| params[x]} << {:include => [:comments]}))
    @post = @blog.posts.published.find_by_permalink(params[:permalink], :include => [:comments])
    redirect_to posts_path and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @post
  end

end
