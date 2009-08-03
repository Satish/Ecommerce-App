class Admin::OrdersController < Admin::BaseController

  before_filter :find_order, :except => [:index]

  def index
    options = { :page => params[:page], :conditions => conditions }
    @orders = @store.orders.search(params[:search], options)
  end

  def show

  end

  #----------------------------------- private -----------------------------
  private

  def find_order
    @order = @store.orders.find_by_number(params[:id])
  end

  def conditions
    sql = ''
    sql << "orders.state = '#{ params[:status].downcase }'" if params[:status] and Order.aasm_states.collect(&:name).include?(params[:status].downcase.to_sym)
    sql
  end

end
