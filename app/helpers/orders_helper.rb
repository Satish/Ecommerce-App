module OrdersHelper

  def options_for_payment_type_select(store)
    []#store.payment_gateways.active.collect{|pg| [pg.name, pg.name] }
  end

  def card_type_options_for_select
    []#Order::CARD_TYPE
  end
  
  def year_options_for_select
   (Time.now.year..Time.now.year+30).to_a
  end
  
  def month_options_for_select
    (1..12).to_a
  end

  def billing_country_options_for_select
    Country.all.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end

  def shipping_country_options_for_select
    @store.countries.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end


end
