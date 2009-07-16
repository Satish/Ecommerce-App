# == Schema Information
#
# Table name: store_countries
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

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
