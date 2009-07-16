class StoreCountry < ActiveRecord::Base
  
  validates_presence_of :store_id, :country_id
  validates_uniqueness_of :country_id, :scope => :store_id

  belongs_to :store
  belongs_to :country

  after_destroy :delete_shipping_countries
  
  def delete_shipping_countries
    ShippingCountry.destroy(store.shipping_countries.find_all_by_country_id(country).collect(&:id))
  end

end
