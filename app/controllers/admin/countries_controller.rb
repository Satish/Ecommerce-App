class Admin::CountriesController < Admin::BaseController

  def index
    options = { :page => params[:page] }
    @countries = Country.search(params[:search], @store.country_ids, options)
  end

end
