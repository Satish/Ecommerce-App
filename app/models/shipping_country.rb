# == Schema Information
#
# Table name: shipping_countries
#
#  id                 :integer(4)      not null, primary key
#  shipping_method_id :integer(4)
#  store_country_id   :integer(4)
#  country_id         :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class ShippingCountry < ActiveRecord::Base

  validates_presence_of :store_country_id, :shipping_method_id, :country_id
  validates_uniqueness_of :country_id, :scope => [:shipping_method_id]
  validates_uniqueness_of :store_country_id, :scope => [:shipping_method_id]

  belongs_to :shipping_method
  belongs_to :store_country
  belongs_to :country

  before_validation :assign_country_id

  #----------------------------------- private -----------------------------
  private

  def assign_country_id
    self.country_id = store_country.country_id
  end

end
