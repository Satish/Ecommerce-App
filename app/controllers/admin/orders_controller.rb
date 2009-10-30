class Admin::OrdersController < Admin::BaseController

  before_filter :find_order, :only => [:show, :edit, :update, :delete]

  def index
    options = { :page => params[:page], :conditions => conditions }
    @orders = @store.orders.search(params[:search], options)
  end

  def show
    @line_items = @order.line_items.all(:include => [{ :sku => [:product, { :attribute_values => [:product_attributes]} ] }])
  end

  def update
    respond_to do |format|
      format.html do
        if @order.update_attributes(params[:order])
          flash[:message] = "Order updated successfully"
          redirect_to [:edit, :admin, @order]
        else
          render :edit
        end
      end
      format.js do
        @status = case params[:status]
        when 'Process'
          @order.process!
        when 'Hold'
          @order.hold!
        when 'Reject'
          @order.reject!
        when 'Ship'
          @order.ship!
        when 'Fulfill'
          @order.fulfill!
        when 'Delete'
          @order.delete!
        else
          false
        end

      end
    end
  end

  def get_state_options
    respond_to do |format|
      format.html { redirect_to new_order_path }
      format.js { render :partial => "state_options", :locals => { :country => params[:country], :state => nil,  :address_type => params[:address_type], :source => params[:source] } }
    end
  end

  #----------------------------------- private -----------------------------
  private

  def find_order
    @order = @store.orders.find_by_number(params[:id], :include => [{:shipment => [:shipping_method]}, :line_items] )
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
