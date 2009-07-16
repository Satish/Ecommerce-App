module Admin::ShippingMethodsHelper

  def country_options_for_select
    @store.countries.collect{|country| ["#{ country.name } (#{ country.iso })", country.id]}
  end

end
