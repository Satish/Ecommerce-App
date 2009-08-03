class OrdersController < ApplicationController

  ssl_required :new, :create, :edit, :update if Rails.env == 'production'

  before_filter :find_store
  before_filter :cart_item_required, :only => [:new, :create]
  before_filter :build_order, :only => [:create]
  before_filter :login_required, :only => [:show]
  before_filter :find_order, :only => [:edit, :update, :destroy]

  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = current_user.orders.find_by_number(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
    @order.shipping_address = ShippingAddress.new#(:country => "United States")
    @order.billing_address = BillingAddress.new#(:country => "United States")
    @order.checkout_step = 1
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  def get_state_options
    respond_to do |format|
      format.html { redirect_to new_order_path }
      format.js { render :partial => "state_options", :locals => { :country => params[:country], :state => nil,  :object => params[:address_type] } }
    end
  end

  # POST /orders
  # POST /orders.xml
  def create
    respond_to do |format|
      if @store.orders << @order
        session[:order_id] = @order.number
        format.html { redirect_to_order_checkout_next_step }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    redirect_to_order_checkout_next_step unless ('1'..'3').to_a.include?(params[:checkout_step]) && ((@order.checkout_step + 1) >= params[:checkout_step].to_i)
    @order.checkout_step = params[:checkout_step]
    @order.shipping_method_id = @shipment.shipping_method_id if (@shipment = @order.shipment) && @order.checkout_step?(2)
  end

  def update
    @order.attributes = params[:order]
    case @order.checkout_step
    when 1
      @order.shipping_address.update_attributes params[:shipping_address]
      @order.billing_address.update_attributes params[:billing_address]
    when 2,3
    else
      redirect_to_order_checkout_next_step and return
    end
    if @order.save
      if @order.checkout_step?(3)
        session[:order_id] = nil
        flash[:message] = 'Order created successfully.'
        redirect_to( logged_in? ? @order : root_path) and return
      else
        redirect_to_order_checkout_next_step and return
      end
    else
      render :action => 'edit' and return
    end
  end

  #----------------------------------- private -----------------------------
  private

  def redirect_to_order_checkout_next_step
    if @order.checkout_step?(3)
      redirect_to( logged_in? ? @order : root_path) and return
    else
      redirect_to edit_order_path(@order, :checkout_step => @order.checkout_step + 1 ) and return
    end
  end

  def cart_item_required
    flash[:notice] = "Please add an item to your cart to place an order." and redirect_to cart_path if current_cart.empty?
  end

  def build_order
    @order = Order.new(params[:order])
    @order.shipping_address = ShippingAddress.new(params[:shipping_address])
    @order.billing_address = BillingAddress.new(params[:billing_address])
    @order.user = current_user
    build_order_items
  end

  def build_order_items
    current_cart.cart_items.each do |item|
      @order.line_items.build( (item[:item_type] == "Sku" ? :sku_id : '') => item[:item_id], :quantity => item[:qty], :price => item[:price] * item[:qty])
    end
  end

  def find_order
    @order = @store.orders.checking_out.find_by_number(session[:order_id])
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to orders_path and return unless @order
  end

end
