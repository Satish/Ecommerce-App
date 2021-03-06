class CartsController < ApplicationController

  include ActionView::Helpers::TextHelper
  before_filter :find_store
  before_filter :current_cart

  def show
    respond_to do |format|
      format.html { @meta_title = "#{ @store.display_name } | Cart" }
      format.js
    end
  end
  
  def create
    if item = find_item
      item_qty = params[:item_qty] ? params[:item_qty].to_i : 0
      @cart.add_item(item, item_qty)
      flash_message(item)
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
        end
      end
      flash_message
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
      flash_message
    else
      flash[:error] = BAD_REQUEST_ERROR_MESSAGE
    end
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

  def empty
    @cart.empty
    flash[:message] = "All items deleted from your cart successfully."
    respond_to do |format|
      format.html { redirect_to get_url_to_back(cart_path) and return }
      format.js
    end
  end

  # ---------------------------- private ---------------------------------
  private

  def flash_message(item = nil)
    if @cart.errors.empty?
      flash[:message] = item ? "Product '#{ h(item.display_name) }' added to your cart successfully.": "Cart updated successfully."
    else
      flash[:error] = "#{ (@cart.errors.collect{ |error| '- ' + h(error) + '<br/>' }) }"
      @cart.errors.clear
    end
  end

end