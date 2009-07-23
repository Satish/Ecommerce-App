class Admin::MailSettingsController < Admin::BaseController

  before_filter :find_mail_setting
  before_filter :set_metas, :only => [:show]

  def show
    redirect_to [:edit, :admin, MailSetting.new]
  end

  def edit; end

  def update
    if @mail_setting.update_attributes(params[:mail_setting])
      flash[:message] = "Mail Settings updated successfully"
      redirect_to [:admin, MailSetting.new]
    else
      render :action => :edit
    end
  end

  private #######################

  def find_mail_setting
    @mail_setting = @store.mail_setting
    [:edit, :admin, Store.new] and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @mail_setting
  end

  def set_metas
    @meta_title = 'Mail Settings'
  end

end
