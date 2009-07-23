class Admin::GatewaysController < Admin::BaseController

  def index
    options = {:page => params[:page]}
    @store_gateways = @store.store_gateways.search(params[:search], options)
  end
 
end
