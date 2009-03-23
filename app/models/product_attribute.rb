# == Schema Information
#
# Table name: product_attributes
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  store_id   :integer(4)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class ProductAttribute < ActiveRecord::Base
  
  @@per_page = 5
  cattr_reader :per_page
  attr_protected :store_id
  
  validates_presence_of :name, :store_id
  validates_uniqueness_of :name, :scope => :store_id
  
  has_many :attribute_values, :dependent => :destroy
  belongs_to :store
  
  def self.search(query, options)
    conditions = ["name like ?", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, name"}    
    paginate default_options.merge(options)
  end
   
  def after_save
    attribute_values.each do |attribute_value|
      attribute_value.update_attribute(:status, active?)
    end
  end
  
end
