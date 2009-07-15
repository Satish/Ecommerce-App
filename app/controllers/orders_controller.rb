class OrdersController < ApplicationController

  ssl_required :new, :create if Rails.env == 'production'
  
  before_filter :find_store
  before_filter :login_required, :only => [:show, :destroy]
  before_filter :find_order, :only => [:show, :destroy]

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
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
    @order.shipping_address = ShippingAddress.new(:country => "United States")
    @order.billing_address = BillingAddress.new(:country => "United States")
    @order.line_items.build
    @order.total_amount = current_cart.total_price
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  def get_state_options
    respond_to do |format|
      format.html { redirect_to new_order_path }
      format.js { render :partial => "state_options", :locals => {:country => params[:country], :state => nil,  :object => params[:address_type]} }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.shipping_address = ShippingAddress.new(params[:shipping_address])
    @order.billing_address = BillingAddress.new(params[:billing_address])
    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order created successfully.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
