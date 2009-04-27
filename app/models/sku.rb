# == Schema Information
#
# Table name: skus
#
#  id               :integer(4)      not null, primary key
#  number           :string(255)
#  quantity         :integer(4)      default(0)
#  additional_price :float           default(0.0)
#  product_id       :integer(4)
#  deleted_at       :datetime
#  active           :boolean(1)      default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

class Sku < ActiveRecord::Base
  
  @@per_page = PER_PAGE
  cattr_reader :per_page
  
  validates_presence_of :number, :quantity, :additional_price, :product_id
  validates_uniqueness_of :number, :scope => :product_id
  
  has_many :attribute_values, :dependent => :destroy

  belongs_to :product

  def before_validation
    self.number = rand(5) if number.blank?
  end
  
  def after_create
    update_attribute(:number, "SKU#{id + 251}")
  end
  
  def self.search(query, options)
    conditions = ["number like ?", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, number"}
    
    paginate default_options.merge(options)
  end
  

  def new_attribute_value_attributes=(attribute_value_attributes)
    attribute_value_attributes.each do |attributes|
      self.attribute_values.build(attributes)
    end
  end

  def existing_attribute_value_attributes=(attribute_value_attributes)
    attribute_values.reject(&:new_record?).each do |attribute_value|
      attributes = attribute_value_attributes[attribute_value.id.to_s]
      if attributes
        attribute_value.attributes = attributes
      else
        attribute_values.delete(attribute_value)
      end
    end
  end
   
end
