# == Schema Information
#
# Table name: countries
#
#  id         :integer(4)      not null, primary key
#  name       :string(80)
#  iso_name   :string(80)
#  iso        :string(2)
#  iso3       :string(3)
#  numcode    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  store_id   :integer(4)
#

class Country < ActiveRecord::Base

  validates_presence_of   :name, :iso_name, :iso, :iso3, :numcode
  validates_uniqueness_of :name, :iso_name, :iso, :iso3, :numcode

  has_many :states
  has_many :shipping_methods

  has_many :store_countries, :dependent => :destroy
  has_many :stores, :through => :store_countries

end
