class CartsController < ApplicationController

  before_filter :find_store
  before_filter :current_cart

  def show
    @meta_title = "#{@store.display_name} | Cart"
  end
  
  def create
    item_id, item_qty = params[:item_id].to_i, params[:item_qty].to_i
    if item = @store.skus.find_by_id(item_id)
      if item_qty > 0
        unless item.is_out_of_stock?
          @cart.add_item(item, item_qty)
          flash[:message] = "Product added to your cart successfully."
        else
          flash[:notice] = "Soory, we are unable to add out of stock product to your cart."
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