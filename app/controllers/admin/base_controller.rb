class Admin::BaseController < ApplicationController
    
  layout 'admin'

  uses_tiny_mce(:options => AppConfig.advanced_mce_options, :only => [:new, :edit, :create, :update])
   
end
