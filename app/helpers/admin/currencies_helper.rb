module Admin::CurrenciesHelper

  def options_for_currency_country_select
    @store.countries.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end

end
