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

  has_many :states, :dependent => :destroy
  belongs_to :store
  belongs_to :country

  after_destroy :delete_shipping_countries
  
  def delete_shipping_countries
    ShippingCountry.destroy(store.shipping_countries.find_all_by_country_id(country).collect(&:id))
  end

  def self.search(query, options)
    conditions = ["countries.name like ? or countries.iso like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "countries.name", :include => [:country, :states]}

    paginate default_options.merge(options)
  end

end
