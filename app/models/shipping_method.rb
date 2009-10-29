# == Schema Information
#
# Table name: shipping_methods
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  store_id   :integer(4)
#  status     :string(10)      default("Active")
#  created_at :datetime
#  updated_at :datetime
#  price      :decimal(8, 2)   default(0.0)
#

class ShippingMethod < ActiveRecord::Base

  include AASM

  @@per_page = PER_PAGE
  cattr_reader :per_page

  attr_protected :store_id

  validates_presence_of :name, :store_id, :price
  validates_uniqueness_of :name, :scope => :store_id
  validates_numericality_of :price, :greater_than_or_equal_to => 0

  default_scope :order => "shipping_methods.created_at DESC, shipping_methods.name"
  named_scope :active, :conditions => { :status => 'active' }
  
  has_many :shipping_countries, :dependent => :destroy
  has_many :store_countries, :through => :shipping_countries
  has_many :countries, :through => :shipping_countries

  belongs_to :store

  after_save :delete_unselected_shipping_countries

  aasm_column :status
  aasm_initial_state :initial => :active
  aasm_state :active
  aasm_state :inactive

  aasm_event :active do
    transitions :from => [:inactive], :to => :active
  end

  aasm_event :inactive do
    transitions :from => [:active], :to => :inactive
  end

  def store_country_ids=new_or_existing_store_country_ids
    new_or_existing_store_country_ids.collect!(&:to_i)
    new_store_country_ids = StoreCountry.find_all_by_id(new_or_existing_store_country_ids.collect{|v| v.to_i} - store_country_ids, :select => "id").collect(&:id)
    @deleted_store_country_ids = store_country_ids - new_or_existing_store_country_ids
    self.store_countries << StoreCountry.find_all_by_id(new_store_country_ids)
  end

  def shipping_countries_names
    shipping_countries.collect{ |shipping_country| shipping_country.country.name }.sort{|x,y| x <=> y }
  end

  def self.search(query, options)
    conditions = ["shipping_methods.name like ? OR countries.name like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = { :conditions => conditions, :include => [:countries] }

    paginate default_options.merge(options)
  end

  #----------------------------------- private -----------------------------
  private

  def delete_unselected_shipping_countries
    ShippingCountry.delete_all(["store_country_id IN (?)", @deleted_store_country_ids]) unless @deleted_store_country_ids.empty?
  end

end
