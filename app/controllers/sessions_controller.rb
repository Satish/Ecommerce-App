# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    redirect_back_or_default(current_user.has_role?('admin') ? admin_root_path : root_path) if current_user
  end

  def create
    logout_keeping_session!
    user = @store.users.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      user.update_visited_at
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:message] = "Logged in successfully."
      respond_to do |format|
        format.html { redirect_back_or_default(user.has_role?('admin') ? admin_root_path : root_path) }
        format.js
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      respond_to do |format|
        format.html { render :action => 'new' }
        format.js
      end
    end
  end

  def destroy
    logout_keeping_session!
    flash[:notice] = "You have been logged out successfully."
    redirect_to get_url_to_back
  end

  protected ###########################
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{ params[:login] }'."
    logger.warn "Failed login for '#{ params[:login] }' from #{ request.remote_ip } at #{ Time.now.utc }"
  end
 
end
