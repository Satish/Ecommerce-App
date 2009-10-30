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
  #validates_associated :attribute_values

  has_many :attribute_values, :dependent => :destroy
  belongs_to :product

  after_update :save_attribute_values
  after_create :activate_product
  after_destroy :deactivate_product

  def activate_product
    product.update_attribute(:active, true) if product.skus.count == 1
  end

  def deactivate_product
    product.update_attribute(:active, false) if product.skus.count == 0
  end

  def before_validation
    self.number = rand(5) if number.blank?
  end
  
  def after_create
    update_attribute(:number, "SKU#{ id + 251 }") if number.blank?
  end
  
  def self.search(query, options)
    conditions = ["skus.number like ? OR skus.quantity like ? OR attribute_values.value like ?", "%#{ query }%", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "skus.created_at DESC, skus.number", :include => query.blank? ? nil : [:attribute_values]}
    
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
      attribute_value.attributes = attributes if attributes
#      if attributes
#        attribute_value.attributes = attributes
#      else
#        attribute_values.delete(attribute_value)
#      end
    end
  end

  def save_attribute_values
    attribute_values.each do |attribute_value|
      attribute_value.save(false)
    end
  end

  def is_out_of_stock?
    return !(self.quantity > 0)
  end

  def price
    product.price + additional_price
  end
  
  def original_price
    product.original_price + additional_price
  end
  
  def total_discount
    product.discount
  end
  
  def percent_discount
    ((product.discount * 100) / original_price).to_i
  end

  def our_price
    original_price - total_discount
  end

  def display_name
    product.name
  end

end
