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

#  def options_for_card_expiration_date_select
#    { :include_blank => true,
#      :add_month_numbers => true,
#      :discard_day => true,
#      :prompt => { :month => 'Select month', :year => "Select year" },
#      :start_year => Time.zone.now.year,
#      :end_year => Time.zone.now.year + 30,
#      :order => [:day, :month, :year],
#      :year_separator => '/'
#    }
#  end

  def select_options_for_creditcard_month
    Date::MONTHNAMES.compact
  end

  def select_options_for_creditcard_year
    (Time.zone.now.year..Time.zone.now.year+30).to_a
  end

  def billing_country_options_for_select
    Country.all.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end

  def shipping_country_options_for_select
    @store.countries.collect{|country| ["#{ country.name } (#{ country.iso })", country.name]}
  end


end
