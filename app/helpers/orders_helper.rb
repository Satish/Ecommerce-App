module OrdersHelper

  def select_options_for_payment_type
    PAYMENT_TYPES
  end

  def select_options_for_shipping_method
    @store.shipping_methods.active.collect{|shipping_method| [shipping_method.name, shipping_method.id] }
  end

  def select_options_for_card_type
    CARD_TYPES
  end

  def select_options_for_creditcard_month
    VALID_MONTHS
  end

  def select_options_for_creditcard_year
    VALID_EXPIRY_YEARS
  end

  def options_for_billing_country_select
    Country.all.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end

  def options_for_shipping_country_select
    @store.countries.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end

end
