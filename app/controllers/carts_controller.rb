class CartsController < ApplicationController

  include ActionView::Helpers::TextHelper
  before_filter :find_store
  before_filter :current_cart

  def show
    debugger
    @meta_title = "#{@store.display_name} | Cart"
  end
  
  def create
    if item = find_item
      item_qty = params[:item_qty] ? params[:item_qty].to_i : nil
      if item_qty > 0
        if item_qty <= item.quantity
          unless item.is_out_of_stock?
            @cart.add_item(item, item_qty)
            flash[:message] = "Product added to your cart successfully."
          else
            flash[:notice] = "Soory, we are unable to add out of stock product to your cart."
          end
        else
          flash[:error] = "Soory, we have only #{ pluralize(item.quantity, 'item')} in stock"
        end
      else
        flash[:notice] = "Qty. must be at least one."
      end
    else
      flash[:error] = "You must select required options to add product to your cart."
    end
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

  def find_item
    item_id = params[:item_id]
    attribute_values = params[:attribute_values] ? params[:attribute_values].split(',') : nil
    item = @store.skus.find_by_id(item_id)
    unless item
      @store.skus.all(:conditions => { :product_id => params[:product_id] }).each do |sku|
        item = sku and break if sku.attribute_values.collect(&:value) == attribute_values
      end
    end
    item
  end

  def update
    if params[:cart_items]
      params[:cart_items].each do |id, qty|
        id, qty = id.to_i, qty.to_i
        if item = @cart.find_by_id(id)
          @cart.update_item(id, qty)
          flash[:message] = "Cart updated successfully."
        end
      end
    else
      flash[:error] = BAD_REQUEST_ERROR_MESSAGE
    end
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

  def destroy
    if item = @cart.find_by_id(params[:id].to_i)
      @cart.remove_item(params[:id].to_i)
      flash[:message] = "Item removed from cart successfully."
    else
      flash[:error] = BAD_REQUEST_ERROR_MESSAGE
    end
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

  def update_item
    id, qty = params[:id].to_i, params[:qty].to_i
    if @item = @cart.find_by_id(id)
      @cart.update_item(id, qty)
      flash[:message] = "Cart updated successfully."
    else
      flash[:error] = BAD_REQUEST_ERROR_MESSAGE
    end
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

end