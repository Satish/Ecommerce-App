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
      format.html do
        redirect_to get_url_to_back(cart_path) and return
      end
      format.js  do
        render :update do |page|
          
        end
      end
    end
  end
  
  def update
    respond_to do |format|
      format.html  do
        if params[:cart_items]
          params[:cart_items].each do |id, qty|
            if item = @cart.find_by_id(id.to_i)
              @cart.update_item(id.to_i, qty.to_i)
              flash[:message] = "Cart Updated Successfully."
            end
          end
        else
          flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE
        end
        redirect_to get_url_to_back(cart_path) and return
      end
      format.js  do
        render :update do |page|
          
        end
      end
    end
  end

end
