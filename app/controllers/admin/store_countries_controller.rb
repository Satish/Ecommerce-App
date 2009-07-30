class Admin::StoreCountriesController < Admin::BaseController

  def index
    options = { :page => params[:page] }
    @store_countries = @store.store_countries.search(params[:search], options)
  end

  def create
    respond_to do |format|
      format.html do
        if params[:country_ids]
          @countries = Country.find_all_by_id(params[:country_ids], :conditions => ["id NOT IN (?)", @store.country_ids])
          flash[:message] = "#{ @countries.size } #{ @countries.size == 1 ? 'country' : 'countries' } added successfully to your store countries" if @store.countries << @countries
        end
        redirect_to [:admin, Country.new] and return
      end
      format.js do
        @country = Country.find_by_id(params[:country_id], :conditions => ["id NOT IN (?)", @store.country_ids])
        @success = (@country and @store.countries) << @country ? true : false
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to [:admin, StoreCountry.new] and return }
      format.js do
        @store_country = @store.store_countries.find_by_id(params[:id])
        @success = (@store_country and @store_country.destroy) ? true : false
      end
    end
    
  end

  def remove
    respond_to do |format|
      format.html do
        @store_countries = @store.store_countries.find_all_by_id(params[:store_country_ids]).collect(&:id)
        flash[:message] = "#{ @store_countries.size } #{ @store_countries.size == 1 ? 'country' : 'countries' } removed successfully from your store countries" if StoreCountry.destroy_all(["store_countries.id IN (?)", @store_countries ])
        redirect_to [:admin, StoreCountry.new] and return
      end
      format.js
    end
  end

end
