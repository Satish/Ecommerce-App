module Admin::ShippingMethodsHelper

  def options_for_store_country_select
    @store.store_countries.collect{|store_country| ["#{ store_country.country.name } (#{ store_country.country.iso })", store_country.id]}
  end

end
