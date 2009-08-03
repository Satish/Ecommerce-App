class Admin::ShipmentsController < Admin::BaseController

  before_filter :find_order

  def edit
    @shipment = @order.shipment
  end

  #------------------------- private ----------------------------
  private

  def find_order
    @order = @store.orders.find_by_number(params[:order_id])
    redirect_to_orders_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @order
  end

  def conditions
    sql = ''
    sql << "orders.state = '#{ params[:status].downcase }'" if params[:status] and Order.aasm_states.collect(&:name).include?(params[:status].downcase.to_sym)
    sql
  end

  def redirect_to_orders_home
    redirect_to [:admin, Order.new] and return
  end

end
