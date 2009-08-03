class Admin::DashboardController < Admin::BaseController
  
  def index
    @pending_orders = @store.orders.pending
    @incomplete_orders = @store.orders.checking_out
    @on_hold_orders = @store.orders.on_hold
  end

end
