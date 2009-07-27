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
#

class ShippingMethod < ActiveRecord::Base

  include AASM

  @@per_page = PER_PAGE
  cattr_reader :per_page

  attr_protected :store_id

  validates_presence_of :name, :store_id
  validates_uniqueness_of :name, :scope => :store_id
  
  named_scope :active, :conditions => { :status => 'active'}
  
  has_many :shipping_countries, :dependent => :destroy
  has_many :countries, :through => :shipping_countries

  belongs_to :store

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

  def after_save
    @deleted_countries.each{|shipping_country| shipping_country.destroy} if @deleted_countries
  end

  def selected_shipping_countries=(ssc)
    if ssc
      @deleted_countries = []
      shipping_countries.each{|shipping_country|  @deleted_countries << shipping_country unless ssc.include?(shipping_country.country_id)}
      (ssc - shipping_country_ids).each{ |sc| shipping_countries.build(:country_id => sc) }
    end
  end
  
  def selected_shipping_countries
    shipping_country_ids
  end
  
  def shipping_countries_names
    shipping_countries.collect{|shipping_country| shipping_country.country.name }
  end

  def self.search(query, options)
    conditions = ["shipping_methods.name like ? OR countries.name like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :include => [:countries], :order => "shipping_methods.created_at DESC, shipping_methods.name"}

    paginate default_options.merge(options)
  end

end
