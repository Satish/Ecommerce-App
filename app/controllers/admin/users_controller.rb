class Admin::UsersController < Admin::BaseController
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:show, :edit, :update, :destroy, :suspend, :unsuspend, :destroy, :purge]
  
  def index
    options = { :page => params[:page] }
    @users = @store.users.search(params[:search], options)
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @users }
    end
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(params[:user])
    @user.store = @store
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      flash[:notice] = "User '#{ @user.login }' created successfully."
      redirect_to [:admin, User.new]
    else
      render :action => 'new'
    end
  end

  def show
    redirect_to [:edit, :admin, @user]
  end

  def edit; end

  def update
    message = "User <em>#{ @user.login }</em> "
    case params[:state]
    when 'activate'
      flash[:message] =  message + "activated successfully." if @user.activate!
    when 'delete'
       flash[:message] = message + "deleted successfully." if @user.delete!
    when 'suspend'
      flash[:message] = message + "suspended successfully." if @user.suspend!
    when 'unsuspend'
      flash[:message] = message + "unsuspended successfully." if @user.unsuspend!
    when 'purge'
      flash[:message] = message + "deleted from database successfully." if @user.destroy
    else
      if @user.update_attributes(params[:user])
        flash[:message] = message + "updated successfully."
      else
        render :action => 'edit'
      end
    end
    flash[:message] = "User state changed to #{ @order.state }" unless flash[:message]
    redirect_to_users_home
  end

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def find_user
    @user = User.find_by_id(params[:id])
    redirect_to_users_home unless @user
  end

  def redirect_to_users_home
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to [:admin, User.new] and return
  end

end
