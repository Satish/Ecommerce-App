# == Schema Information
#
# Table name: shipping_countries
#
#  id                 :integer(4)      not null, primary key
#  shipping_method_id :integer(4)
#  country_id         :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class ShippingCountry < ActiveRecord::Base

  validates_presence_of :country_id#, :shipping_method_id
  validates_uniqueness_of :country_id, :scope => [:shipping_method_id]

  belongs_to :shipping_method
  belongs_to :country

end
