class Admin::CommentsController < Admin::BaseController
  
  before_filter :find_blog
  before_filter :find_post
  before_filter :find_comment, :only => [:show, :edit, :update, :destroy]
#  before_filter :owner_required, :only => [:edit, :update, :destroy]
  
  def index
    options = {:page => params[:page]}
    @comments = @post.comments.search(params[:search], options)
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml{ render :xml => @comments }
    end
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user.display_name
    @comment.author_email = current_user.email
    if @post.comments << @comment
      @comment.approve!
      respond_to do |format|
        format.html do
          flash[:message] = 'Comment Created successfully.'
          redirect_to [:admin, @post, @comment] and return
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
    if @comment.update_attributes(params[:comment])
      respond_to do |format|
        format.html do
          flash[:message] = 'Comment updated successfully.'
          redirect_to [:admin, @post, @comment] and return
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
      format.js do
        render :update do |page|
          if @comment.destroy
            page.remove("comment_#{@comment.id}")
          else
            page.alert(BAD_REQUEST_ERROR_MESSAGE)
          end
        end
      end
      format.html do
        flash[:message] = 'Comment deleted successfully.' if @comment.destroy
        redirect_to_comments_home and return
      end
    end
  end
  
  private #######################
  
  def find_post
    @post = @blog.posts.find_by_id(params[:post_id])
    redirect_to [:admin, Post.new] and return unless @blog
  end
  
  def find_comment
    @comment = @post.comments.find_by_id(params[:id])
    redirect_to_comments_home and return unless @comment
  end
  
  def redirect_to_comments_home
    redirect_to [:admin, @post, Comment.new] and return
  end
  
  def owner_required
    redirect_to_comments_home and return unless current_user.has_ownership?(@comment)
  end
  
end
