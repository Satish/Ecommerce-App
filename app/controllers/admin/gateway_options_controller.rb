class Admin::GatewayOptionsController < Admin::BaseController

  before_filter :find_store_gateway

  def edit; end

  def update
    if @store_gateway.update_attributes(params[:store_gateway])
      flash[:message] = "Gateway Options updated successfully."
      redirect_to [:edit, :admin, @store_gateway.gateway, GatewayOption.new] and return
    else
      render :action => 'edit'
    end
  end

  #------------------------- private ----------------------------
  private

  def find_store_gateway
    @store_gateway = @store.store_gateways.find_by_id(params[:gateway_id])
    redirect_to_gateways_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @store_gateway
  end

  def redirect_to_gateways_home
    redirect_to [:admin, Gateway.new] and return
  end

end
